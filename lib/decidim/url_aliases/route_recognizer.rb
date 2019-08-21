# frozen_string_literal: true

module Decidim
  module UrlAliases
    class RouteRecognizer
      # https://gist.github.com/bantic/5688232

      def find(string_path)
        paths.any? { |path| path.match(string_path) }
      end

      def index_paths
        @index_paths ||= begin
          manifest_names = manifests.map(&:name).map(&:to_s)
          index_routes = routes.select { |route| route.name.in?(manifest_names) }
          index_paths = index_routes.map { |route| route.path.spec.to_s }
          index_paths.map { |path| path.delete("/").remove("(.:format)") }
        end
      end

      private

      def manifests
        Decidim.participatory_space_manifests
      end

      # Return an Array of ActionDispatch::Journey::Path::Pattern
      def paths
        @paths ||= routes.map(&:path)
      end

      # Return an Array of ActionDispatch::Journey::Routes
      def routes
        manifests.map do |manifest|
          engine = manifest.context.engine
          engine.routes.routes
        end.map(&:routes).flatten
      end
    end
  end
end
