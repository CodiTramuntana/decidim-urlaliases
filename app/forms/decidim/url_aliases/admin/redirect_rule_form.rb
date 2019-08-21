# frozen_string_literal: true

module Decidim
  module UrlAliases
    module Admin
      class RedirectRuleForm < Form
        attribute :source, String
        attribute :source_is_case_sensitive, Boolean
        attribute :destination, String
        attribute :active, Boolean
        attribute :organization, Decidim::Organization

        mimic :redirect_rule

        validates :organization, presence: true

        validate :source_uniqueness
        validate :destination_uniqueness
        validates :destination, presence: true, format: { with: Decidim::ParticipatoryProcess.slug_format }
        validates :destination, exclusion: { in: Decidim::UrlAliases::RESERVED_PATHS, message: "%{value} is reserved." }

        alias organization current_organization
        delegate :host, to: :organization

        def scoped_source
          host + "/" + source
        end

        def scoped_destination
          host + "/" + destination
        end

        private

        def source_uniqueness
          return unless RedirectRule.where(source: source).where.not(id: context[:id]).any?

          errors.add(:source, :taken)
        end

        def destination_uniqueness
          return unless RedirectRule.where(destination: destination).where.not(id: context[:id]).any?

          errors.add(:destination, :taken)
        end
      end
    end
  end
end
