# frozen_string_literal: true

require "spec_helper"

describe RedirectRule do
  subject { rule }

  let(:organization) { create(:organization) }
  let(:rule) { create(:redirect_rule, organization: organization) }
  let(:other_rule) { create(:redirect_rule, organization: organization) }

  it { is_expected.to be_valid }

  describe "validations" do
    context "without organization" do
      before { rule.organization = nil }

      it { is_expected.to be_invalid }
    end

    context "without source" do
      before { rule.source = nil }

      it { is_expected.to be_invalid }
    end

    context "without unique source in organization" do
      before { rule.source = other_rule.source }

      it { is_expected.to be_invalid }
    end

    context "without destination" do
      before { rule.destination = nil }

      it { is_expected.to be_invalid }
    end

    context "without unique destination in organization" do
      before { rule.destination = other_rule.destination }

      it { is_expected.to be_invalid }
    end
  end
end
