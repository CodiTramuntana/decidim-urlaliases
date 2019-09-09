# Decidim::UrlAliases

`Decidim::UrlAliases` is a [Decidim](https://github.com/decidim/decidim) module to allow admins to create url aliases for resources within a `Decidim::ParticipatorySpace`.

The module is based on the [Redirector gem](https://github.com/vigetlabs/redirector) and creates an interface for admins to manage redirect rules. Redirect rules have two parts: the _source_ defines how to match the incoming request path and the _destination_ is where to send the visitor if the match is made.

The gem enforces the following restrictions to redirect rules:
- Only paths that match public routes within _participatory spaces_ are allowed as **destination**. Exception will be made for paths starting with "/uploads" (see configuration).
- Paths that can conflict with existing _decidim_ routes are not allowed as **source**. These paths are computed dinamically to allow for changes in decidim. After installation, take a look at `config/url_aliases/reserved_paths.yml` to see which ones they are in your application or take a look at [default_reserved_paths.yml](config/default_reserved_paths.yml) to make yourself an idea. You can expand this list at installation level (see configuration).
- Redirect rules will only have effect when visiting the host of the `Decidim::Organization` in which they were created.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'decidim-urlaliases'
```

And then execute:

```bash
bundle
bundle exec rake url_aliases:init
```

Inside your configuration in `config/application.rb` of your Rails application you can set the following:
```bash
# This option silences the logging of Redirector related SQL queries in your log file
config.redirector.silence_sql_logs = true
```
## Configuration

By overriding the following constants you can:
- Add exeptions to destination validations. Any string that starts with a whitelisted prefix will be allowed as destination.
- Add restrictions for source validation. Any string which is equal to a reserved path will not be allowed as source.

```ruby
# config/initializers/url_aliases.rb
module Decidim
  module UrlAliases
    RouteRecognizer::NEW_RESERVED_PATHS   = %w(/custom_path)  # default: []
    RouteRecognizer::WHITELISTED_PREFIXES = %w(/pages)        # default: ["/uploads"]
  end
end
```

## Usage

- Install the gem
- Login to the application as an administrator.
- Go to the Admin panel > Url Aliases.
- Create a new redirect rule. Choose a custom path as a _source_, copy the path to a resource in your app as _destination_ and make sure to check "Active".
- Visit your custom path inside the organization host and see yourself redirected to the destination that you chose.

Note: the redirect response status is HTTP 302 to prevent caching.

## Testing

1. Run `bundle exec rake test_app`.

2. Run tests with `bundle exec rspec`

## Versioning

`Decidim::UrlAliases` depends directly on `Decidim::Core` in `0.16.1` version.

## Contributing

See [Decidim](https://github.com/decidim/decidim).

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.
