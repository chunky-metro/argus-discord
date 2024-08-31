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
      allow(assistant).to receive(:process_message).with(message).and_return({importance: 0.5, embedding: [0.1, 0.2, 0.3]})
    end

    it "processes the message" do
      expect(assistant).to receive(:process_message).with(message)
      handler.call(event)
    end

    context "when the message is important" do
      before do
        allow(assistant).to receive(:process_message).with(message).and_return({importance: 0.9, embedding: [0.1, 0.2, 0.3]})
      end

      it "notifies about the important message" do
        expect(event).to receive(:respond).with("⚠️ Important announcement detected! ⚠️\nTest message")
        handler.call(event)
      end
    end

    context "when the message contains a project update" do
      let(:message) { instance_double(Discordrb::Message, content: "Project: XYZ has launched a new feature") }

      before do
        allow(assistant).to receive(:analyze_project_update).and_return("Analysis of XYZ update")
      end

      it "analyzes the project update and sends the analysis" do
        expect(assistant).to receive(:analyze_project_update).with("XYZ", "Project: XYZ has launched a new feature")
        expect(event).to receive(:respond).with("📊 Project Update Analysis: XYZ 📊\n\nAnalysis of XYZ update")
        handler.call(event)
      end
    end
  end
end