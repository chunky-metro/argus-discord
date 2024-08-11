# frozen_string_literal: true

require "spec_helper"

RSpec.describe Argus::Discord::Commands::MessageHandler do
  let(:database) { instance_double(Argus::Discord::Database) }
  let(:assistant) { instance_double(Argus::Discord::Assistant) }
  let(:handler) { described_class.new(database, assistant) }

  describe "#initialize" do
    it "sets up the handler with correct dependencies" do
      expect(handler.database).to eq(database)
      expect(handler.assistant).to eq(assistant)
    end
  end

  describe "#call" do
    let(:event) { instance_double(Discordrb::Events::MessageEvent) }
    let(:message) { instance_double(Discordrb::Message, content: "Test message") }

    before do
      allow(event).to receive(:message).and_return(message)
    end

    it "saves the message and processes it" do
      expect(database).to receive(:save_message).with(message)
      expect(assistant).to receive(:process_message).with(message).and_return(0.5)
      handler.call(event)
    end

    context "when the message is important" do
      it "notifies about the important message" do
        allow(database).to receive(:save_message)
        allow(assistant).to receive(:process_message).and_return(0.9)
        expect(event).to receive(:respond).with("⚠️ Important announcement detected! ⚠️\nTest message")
        handler.call(event)
      end
    end
  end
end