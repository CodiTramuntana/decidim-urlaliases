# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gem "decidim", git: "https://github.com/decidim/decidim.git", branch: "release/0.25-stable"
gem "decidim-url_aliases", path: "."
gem "webpacker"

group :development, :test do
  gem "bootsnap", require: true
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", git: "https://github.com/decidim/decidim.git", branch: "release/0.25-stable"
  gem "faker", "~> 2.14"
  gem "listen"
  gem "codecov"
end

group :development do
  gem "letter_opener_web", "~> 2.0"
  gem "web-console", "~> 3.5"
end
