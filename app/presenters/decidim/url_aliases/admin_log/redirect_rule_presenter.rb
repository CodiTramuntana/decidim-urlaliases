# frozen_string_literal: true

module Decidim
  module UrlAliases
    module AdminLog
      # This class holds the logic to present a `Decidim::ParticipatoryProcess`
      # for the `AdminLog` log.
      #
      # Usage should be automatic and you shouldn't need to call this class
      # directly, but here's an example:
      #
      #    action_log = Decidim::ActionLog.last
      #    view_helpers # => this comes from the views
      #    ParticipatoryProcessPresenter.new(action_log, view_helpers).present
      class RedirectRulePresenter < Decidim::Log::BasePresenter
        private

        def diff_fields_mapping
          {
            source: :string,
            destination: :string,
            source_is_case_sensitive: :boolean,
            active: :boolean
          }
        end

        def action_string
          case action
          when "create", "update", "delete"
            "decidim.url_aliases.admin_log.#{action}"
          end
        end

        def i18n_labels_scope
          "url_aliases.admin.models.redirect_rule.fields"
        end

        # Private: The params to be sent to the i18n string.
        #
        # Returns a Hash.
        def i18n_params
          {
            user_name: user_presenter.present,
            resource_name: present_resource,
            resource_id: action_log.resource_id
          }
        end

        def resource
          action_log.resource
        end

        # Private: Presents the resource of the action. If the resource and the
        # space are found in the database, it links to it. Otherwise it only
        # shows the resource name.
        #
        # Returns an HTML-safe String.
        def present_resource
          if resource.blank?
            h.content_tag(:span, resource_name, class: "logs__log__resource")
          else
            h.link_to(resource_name, resource_path, class: "logs__log__resource")
          end
        end

        # Private: Finds the public link for the given resource.
        #
        # Returns an HTML-safe String. If the resource space is not
        # present, it returns `nil`.
        def resource_path
          Decidim::UrlAliases::AdminEngine.routes.url_helpers.redirect_rules_path(anchor: "redirect-rule-#{resource.id}")
        end

        # Private: Presents resource name.
        #
        # Returns an HTML-safe String.
        def resource_name
          RedirectRule.model_name.human
        end
      end
    end
  end
end
