# frozen_string_literal: true

require "rails"
require "decidim/core"
require "redirector"

module Decidim
  module UrlAliases
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::UrlAliases

      initializer "decidim_url_aliases.assets" do |app|
        app.config.assets.precompile += %w(decidim_url_aliases_manifest.js)
      end
      # make decorators autoload in development env
      config.autoload_paths << File.join(
        Decidim::UrlAliases::Engine.root, "app", "decorators", "{**}"
      )

      # make decorators available to applications that use this Engine
      config.to_prepare do
        Dir.glob(Decidim::UrlAliases::Engine.root + "app/decorators/*_decorator*.rb").each do |c|
          require_dependency(c)
        end
        Dir.glob(Decidim::UrlAliases::Engine.root + "app/decorators/**/*_decorator*.rb").each do |c|
          require_dependency(c)
        end
      end
    end
  end
end
