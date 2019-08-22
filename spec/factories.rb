# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :redirect_rule do
    active true
    source_is_regex false
    source '/catchy_thingy'
    destination 'http://www.example.com/products/1'
    organization { create(:organization) }
  end
end
