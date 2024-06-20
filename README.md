# Active Storage Bunny

[Bunny](https://bunny.net/storage/) is a fast, powerful, cheap and reliable CDN service and offers a storage service that can be used to store files which is a great alternative to Amazon S3, Azure, and Google Cloud Storage.

Active Storage Bunny is a gem that integrates BunnyCDN Storage services with Active Storage. This gem acts as an adapter to add BunnyCDN as a service to Active Storage.

This uses [BunnyStorage Client](https://github.com/rkwap/bunny_storage_client?tab=readme-ov-file#bunnystorage-client) gem to interact with BunnyCDN storage services.

[![Gem Version](https://badge.fury.io/rb/active_storage_bunny.svg)](https://badge.fury.io/rb/active_storage_bunny)

## Table of Contents

- [Installation](#installation)
- [Requirements](#requirements)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [License](#license)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_storage_bunny'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install active_storage_bunny
```

## Requirements

- Ruby version >= 2.5
- Rails version >= 6.0
- [BunnyStorage Client gem](https://rubygems.org/gems/bunny_storage_client) (will be installed as a dependency)

## Configuration

Configure Active Storage to use the Bunny service by adding the following to your `config/storage.yml`:

```yaml
bunny:
  service: Bunny
  access_key: <%= ENV['BUNNY_ACCESS_KEY'] %>
  api_key: <%= ENV['BUNNY_API_KEY'] %>
  storage_zone: <%= ENV['BUNNY_STORAGE_ZONE'] %>
```

Then, in your environment configuration file (e.g., `config/environments/production.rb`), set the Active Storage service:

```ruby
config.active_storage.service = :bunny
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rkwaap/active_storage_bunny

1. Fork the repository.
2. Create a new branch (git checkout -b my-new-feature).
3. Commit your changes (git commit -am 'Add some feature').
4. Push to the branch (git push origin my-new-feature).
5. Create a new Pull Request.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).