# frozen_string_literal: true

require "spec_helper"

describe Decidim::UrlAliases::RouteRecognizer do
  let(:route_recognizer) { described_class.new }
  let(:rule) { create(:redirect_rule) }

  describe "#matching_path?" do
    subject { route_recognizer.matching_path?(request_path) }

    context "when the request_path is a valid decidim path" do
      let(:request_path) { rule.destination }

      it { is_expected.to be(true) }
    end

    context "when the request_path is NOT a valid decidim path" do
      let(:request_path) { "/invalid/path" }

      it { is_expected.to be(false) }
    end

    context "when the request_path is in WHITELISTED_PREFIXES" do
      let(:request_path) { "/uploads" }

      it { is_expected.to be(true) }
    end
  end

  describe "#reserved_path?" do
    subject { route_recognizer.reserved_path?(request_path) }

    context "when the request_path is NOT a reserved_path" do
      let(:request_path) { "/my-custom-url" }

      it { is_expected.to be(false) }
    end

    context "when the request_path is a reserved_path" do
      let(:request_path) { "/admin" }

      it { is_expected.to be(true) }
    end

    context "when the request_path is in NEW_RESERVED_PATHS" do
      let(:request_path) { "/custom_path" }

      before { described_class::NEW_RESERVED_PATHS = ["/custom_path"] }

      it { is_expected.to be(true) }
    end
  end
end
