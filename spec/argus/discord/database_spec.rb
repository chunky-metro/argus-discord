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
      expect(client).to receive(:create_schema)
      described_class.new(client: client)
    end
  end

  describe "#save_message" do
    it "saves a message to the database" do
      message = instance_double("Discordrb::Message", content: "Test message", channel: double(id: 123), id: 456, timestamp: Time.now)
      expect(client).to receive(:add_texts).with([message.content], hash_including(:metadata))
      database.save_message(message)
    end
  end

  describe "#query_messages" do
    it "queries messages from the database" do
      expect(client).to receive(:similarity_search).with("test query", k: 10)
      database.query_messages("test query")
    end
  end
end