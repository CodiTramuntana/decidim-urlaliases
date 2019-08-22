# frozen_string_literal: true

require "decidim/url_aliases/admin"
require "decidim/url_aliases/engine"
require "decidim/url_aliases/admin_engine"

module Decidim
  module UrlAliases
    autoload :RouteRecognizer, "decidim/url_aliases/route_recognizer"
    RESERVED_PATHS = %W(/system /admin /api).freeze
  end
end
