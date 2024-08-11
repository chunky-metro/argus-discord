# frozen_string_literal: true

require "spec_helper"

RSpec.describe Argus::Discord::Commands::SummaryHandler do
  let(:assistant) { instance_double(Argus::Discord::Assistant) }
  let(:handler) { described_class.new(assistant) }

  describe "#initialize" do
    it "sets up the handler with correct dependencies" do
      expect(handler.assistant).to eq(assistant)
    end
  end

  describe "#call" do
    let(:event) { instance_double(Discordrb::Events::MessageEvent) }

    it "generates a summary and responds to the event" do
      expect(assistant).to receive(:generate_summary).and_return("Summary")
      expect(event).to receive(:respond).with("Summary")
      handler.call(event)
    end
  end
end