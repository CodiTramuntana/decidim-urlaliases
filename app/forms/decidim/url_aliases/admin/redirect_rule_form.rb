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
        validates :source, presence: true
        validates :destination, presence: true, format: { with: Decidim::ParticipatoryProcess.slug_format }

        validate :source_uniqueness
        validate :destination_uniqueness
        validate :source_must_be_recognized
        validate :destination_must_not_be_reserved
        # validate :host_must_be_valid

        def before_validation
          # self.prepend_host
        end

        alias organization current_organization
        delegate :host, to: :organization

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

        def source_must_be_recognized
          return if route_recognizer.find_path("/" + source)

          errors.add(:source, :not_recognized)
        end

        def destination_must_not_be_reserved
          return unless destination.in?(reserved_paths)

          errors.add(:destination, :reserved)
        end

        def organization_redirect_rules
          RedirectRule.where(organization: organization).where.not(id: id)
        end

        def source_uniqueness
          return unless organization_redirect_rules.where(source: source).any?

          errors.add(:source, :taken)
        end

        def destination_uniqueness
          return unless organization_redirect_rules.where(destination: destination).any?

          errors.add(:destination, :taken)
        end
      end
    end
  end
end
