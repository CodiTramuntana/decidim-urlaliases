# frozen_string_literal: true

module Decidim
  module UrlAliases
    module Admin
      class RedirectRuleForm < Form
        mimic :redirect_rule

        attribute :source, String
        attribute :source_is_case_sensitive, Boolean
        attribute :destination, String
        attribute :active, Boolean
        attribute :organization, Decidim::Organization

        validates :organization, presence: true
        validates :destination, presence: true
        validates :source, presence: true, format: { with: Decidim::ParticipatoryProcess.slug_format }

        validate :source_uniqueness
        validate :source_must_not_be_reserved
        validate :destination_uniqueness
        validate :destination_must_be_recognized

        alias organization current_organization

        def source_only
          remove_host(source)
        end

        def destination_only
          remove_host(destination)
        end

        def full_source
          add_host(source)
        end

        def full_destination
          add_host(destination)
        end

        # delete this
        def organization_host
          "localhost:3000"
        end

        # change organization_host to organization.host
        def host
          "http://#{organization_host}"
        end

        private

        def add_host(path)
          host + "/" + path
        end

        def remove_host(path)
          return "" unless path

          path.remove(host).delete_prefix("/")
        end

        def reserved_paths
          Decidim::UrlAliases::RESERVED_PATHS + route_recognizer.index_paths
        end

        def route_recognizer
          @route_recognizer ||= Decidim::UrlAliases::RouteRecognizer.new
        end

        def source_must_not_be_reserved
          return unless source.in?(reserved_paths)

          errors.add(:source, :reserved)
        end

        def destination_must_be_recognized
          return if route_recognizer.find_path("/" + destination)

          errors.add(:destination, :not_recognized)
        end

        def organization_redirect_rules
          organization.redirect_rules.where.not(id: id)
        end

        def source_uniqueness
          return unless organization_redirect_rules.where(source: full_source).any?

          errors.add(:source, :taken)
        end

        def destination_uniqueness
          return unless organization_redirect_rules.where(destination: full_destination).any?

          errors.add(:destination, :taken)
        end
      end
    end
  end
end
