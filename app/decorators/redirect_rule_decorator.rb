# frozen_string_literal: true

RedirectRule.class_eval do
  include Decidim::Traceable

  belongs_to :organization, foreign_key: :decidim_organization_id, class_name: "Decidim::Organization"

  validates :source,      presence: true, uniqueness: { scope: :organization }
  validates :destination, presence: true, uniqueness: { scope: :organization }

  def self.log_presenter_class_for(_log)
    Decidim::UrlAliases::AdminLog::RedirectRulePresenter
  end
end
