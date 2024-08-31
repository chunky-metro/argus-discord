# frozen_string_literal: true

require "spec_helper"

RSpec.describe Argus::Discord::Database do
  let(:client) { instance_double(Langchain::Vectorsearch::Weaviate) }
  let(:database) { described_class.new(client: client) }

  describe "#initialize" do
    it "sets up the Weaviate client" do
      expect(database.client).to eq(client)
    end

    it "creates the schema" do
      expect(client).to receive(:create_class).with(
        class_name: "DiscordMessage",
        properties: [
          {name: "content", data_type: ["text"]},
          {name: "channel_id", data_type: ["int"]},
          {name: "message_id", data_type: ["int"]},
          {name: "created_at", data_type: ["int"]}
        ]
      )
      described_class.new(client: client)
    end
  end

  describe "#save_message" do
    it "saves a message to the database" do
      message = instance_double(Discordrb::Message, content: "Test message", channel: double(id: 123), id: 456, timestamp: Time.now)
      expect(client).to receive(:add_object).with(
        class_name: "DiscordMessage",
        properties: {
          content: "Test message",
          channel_id: 123,
          message_id: 456,
          created_at: message.timestamp.to_i
        }
      )
      database.save_message(message)
    end
  end

  describe "#query_messages" do
    it "queries messages from the database" do
      expect(client).to receive(:query).with(
        class_name: "DiscordMessage",
        near_text: "test query",
        limit: 10
      ).and_return([])
      database.query_messages("test query")
    end
  end
end