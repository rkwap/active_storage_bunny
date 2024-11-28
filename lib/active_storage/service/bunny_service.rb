# frozen_string_literal: true

require 'active_support/core_ext/numeric/bytes'
require 'bunny_storage_client'

module ActiveStorage
  # Wraps the BunnyCDN Storage as an Active Storage service.
  # See ActiveStorage::Service for the generic API documentation that applies to all services.
  class Service::BunnyService < Service

    attr_reader :client

    def initialize(access_key:, api_key:, storage_zone:, region:, cdn: false)
      @client = BunnyStorageClient.new(access_key, api_key, storage_zone, region)

      if cdn
        @base_url = cdn
      else
        @base_url = "https://#{storage_zone}.b-cdn.net"
      end
    end

    def upload(key, io, checksum: nil, filename: nil, content_type: nil, disposition: nil, custom_metadata: {}, **)
      instrument :upload, key: key, checksum: checksum do
        content_disposition = content_disposition_with(filename: filename, type: disposition) if disposition && filename
        upload_with_single_part key, io, checksum: checksum, content_type: content_type, content_disposition: content_disposition, custom_metadata: custom_metadata
      end
    end

    def download(key, &block)
      if block_given?
        instrument :streaming_download, { key: key } do
          stream(key, &block)
        end
      else
        instrument :download, key: key do
          io = StringIo.new object_for(key).get_file

          io
        end
      end
    end

    def delete(key)
      instrument :delete, key: key do
        object_for(key).delete_file
      end
    end

    def delete_prefixed(prefix)
      delete prefix
      # instrument :delete_prefixed, prefix: prefix do
      #   # BunnyStorageClient does not natively support this operation yet.
      # end
    end

    def exist?(key)
      instrument :exist, key: key do |payload|
        answer = object_for(key).exist?
        payload[:exist] = answer
        answer
      end
    end

    def url(key, expires_in:, disposition:, filename:, **options)
      instrument :url, {key: key} do |payload|
        url = public_url key
        payload[:url] = url

        url
      end
    end

    def url_for_direct_upload(key, expires_in:, content_type:, content_length:, checksum:, custom_metadata: {})
      instrument :url, key: key do |payload|
        generated_url = object_for(key).presigned_url :put, expires_in: expires_in.to_i,
                                                            content_type: content_type, content_length: content_length, content_md5: checksum,
                                                            metadata: custom_metadata, whitelist_headers: ['content-length'], **upload_options

        payload[:url] = generated_url

        generated_url
      end
    end

    def headers_for_direct_upload(key, content_type:, checksum:, filename: nil, disposition: nil, custom_metadata: {}, **)
      content_disposition = content_disposition_with(type: disposition, filename: filename) if filename

      { 'Content-Type' => content_type, 'Content-MD5' => checksum, 'Content-Disposition' => content_disposition, **custom_metadata_headers(custom_metadata) }
    end

    private

    def private_url(key, expires_in:, filename:, disposition:, content_type:, **)
      # BunnyStorageClient does not natively support this operation yet.
      public_url(key)
    end

    def public_url(key)
      File.join(@base_url, key)
    end

    def upload_with_single_part(key, io, checksum: nil, content_type: nil, content_disposition: nil, custom_metadata: {})
      object_for(key).upload_file(body: io)
      object_for(key).purge_cache
    rescue StandardError
      raise ActiveStorage::IntegrityError
    end

    def stream(key, options = {}, &block)
      io = StringIO.new object_for(key).get_file

      chunk_size = 5.megabytes

      while chunk = io.read(chunk_size)
        yield chunk
      end
    end

    def object_for(key)
      client.object(key)
    end
  end
end
