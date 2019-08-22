require 'spec_helper'

describe RedirectRule do
  subject { rule }

  let(:rule) { create(:redirect_rule, organization: organization) }
  let(:organization) { create(:organization) }

  it { is_expected.to be_valid }

  it "belongs to a organization" do
    expect(RedirectRule.reflect_on_association(:organization).macro).to eq(:belongs_to)
  end

  describe "validations" do
    context "with organization" do
      it { is_expected.to be_valid }
    end

    context "without organization" do
      before { rule.organization = nil }

      it { is_expected.to be_invalid }
    end
  end

  describe "#source_only" do

  end

  describe "#destination_only" do
  end
end
