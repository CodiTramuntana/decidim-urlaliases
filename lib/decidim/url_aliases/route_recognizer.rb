# frozen_string_literal: true

module Decidim
  module UrlAliases
    # https://gist.github.com/bantic/5688232
    class RouteRecognizer
      # Checks if the string_path matches any path.
      def find_path(string_path)
        paths.any? { |path| path.match(string_path) }
      end

      # Return an Array[String].
      def index_paths
        @index_paths ||= begin
          manifest_names = manifests.map(&:name).map(&:to_s)
          index_routes = routes.select { |route| route.name.in?(manifest_names) }
          index_paths = index_routes.map { |route| route.path.spec.to_s }
          index_paths.map { |path| path.delete_prefix("/").remove("(.:format)") }
        end
      end

      # Returns an Array[ParticipatorySpaceManifest].
      def manifests
        Decidim.participatory_space_manifests
      end

      # Return an Array[ActionDispatch::Journey::Path::Pattern].
      def paths
        @paths ||= routes.map(&:path)
      end

      # Return an Array[ActionDispatch::Journey::Route].
      def routes
        @routes ||= manifests.map do |manifest|
          engine = manifest.context.engine
          engine.routes.routes
        end.map(&:routes).flatten
      end
    end
  end
end
