# frozen_string_literal: true

require "spec_helper"
require "json"

RSpec.describe Argus::Discord::Commands::MessageHandler do
  let(:database) { instance_double(Argus::Discord::Database) }
  let(:assistant) { instance_double(Argus::Discord::Assistant) }
  let(:embedding_service) { instance_double(Argus::Discord::EmbeddingService) }
  let(:handler) { described_class.new(database, assistant, embedding_service) }
  let(:message_with_embeds) { JSON.parse(File.read("spec/fixtures/message_with_embeds.json")) }

  describe "#initialize" do
    it "sets up the handler with correct dependencies" do
      expect(handler.database).to eq(database)
      expect(handler.assistant).to eq(assistant)
      expect(handler.embedding_service).to eq(embedding_service)
    end
  end

  describe "#call" do
    let(:event) { instance_double(Discordrb::Events::MessageEvent) }
    let(:message) { Discordrb::Message.new(message_with_embeds, nil) }

    before do
      allow(event).to receive(:message).and_return(message)
      allow(assistant).to receive(:process_message).with(message).and_return({importance: 0.5, embedding: [0.1, 0.2, 0.3]})
      allow(embedding_service).to receive(:embed_and_store_message)
    end

    it "processes the message" do
      expect(assistant).to receive(:process_message).with(message)
      handler.call(event)
    end

    it "stores the message using the embedding service" do
      expect(embedding_service).to receive(:embed_and_store_message).with(message)
      handler.call(event)
    end

    context "when the message is important" do
      before do
        allow(assistant).to receive(:process_message).with(message).and_return({importance: 0.9, embedding: [0.1, 0.2, 0.3]})
      end

      it "notifies about the important message" do
        expect(event).to receive(:respond).with("⚠️ Important announcement detected! ⚠️\nThis is a test message with embeds")
        handler.call(event)
      end
    end

    context "when the message contains a project update" do
      let(:message_with_project_update) do
        project_update = message_with_embeds.dup
        project_update["content"] = "Project: XYZ has launched a new feature"
        Discordrb::Message.new(project_update, nil)
      end

      before do
        allow(event).to receive(:message).and_return(message_with_project_update)
        allow(assistant).to receive(:analyze_project_update).and_return("Analysis of XYZ update")
      end

      it "analyzes the project update and sends the analysis" do
        expect(assistant).to receive(:analyze_project_update).with("XYZ", "Project: XYZ has launched a new feature")
        expect(event).to receive(:respond).with("📊 Project Update Analysis: XYZ 📊\n\nAnalysis of XYZ update")
        handler.call(event)
      end
    end

    context "when the message contains embeds" do
      it "processes and stores the message with embeds" do
        expect(embedding_service).to receive(:embed_and_store_message) do |stored_message|
          expect(stored_message.embeds.size).to eq(1)
          expect(stored_message.embeds.first.title).to eq("Test Embed")
          expect(stored_message.embeds.first.fields.size).to eq(2)
        end
        handler.call(event)
      end
    end
  end
end