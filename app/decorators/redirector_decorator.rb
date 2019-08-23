# # frozen_string_literal: true

module Redirector
  class Middleware
    Responder.class_eval do
      private

      def matched_destination
        @matched_destination ||= with_optional_silencing do
          rule = RedirectRule.match_for(request_path, env)
          rule.destination if rule && rule.organization.host == request_host
        end
      end
    end
  end
end
