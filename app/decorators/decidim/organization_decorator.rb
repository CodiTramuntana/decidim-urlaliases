# frozen_string_literal: true

# Commenting this to avoid the following error while generating the test_app:
# TypeError: superclass mismatch for class Organization

# ::Decidim::Organization.class_eval do
#   has_many :redirect_rules, foreign_key: :decidim_organization_id, class_name: "RedirectRule"
# end
