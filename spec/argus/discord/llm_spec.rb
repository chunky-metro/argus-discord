# frozen_string_literal: true

require "spec_helper"

RSpec.describe Argus::Discord::LLM do
  let(:client) { instance_double(Langchain::LLM::OpenAI) }
  let(:database) { instance_double(Argus::Discord::Database) }
  let(:llm) { described_class.new(client: client, database: database) }

  describe "#initialize" do
    it "sets up the OpenAI client" do
      expect(llm.client).to eq(client)
    end

    it "sets up the database" do
      expect(llm.database).to eq(database)
    end
  end

  describe "#embed" do
    it "embeds text using the OpenAI client" do
      expect(client).to receive(:embed).with(text: "test text")
      llm.embed("test text")
    end
  end

  describe "#summarize" do
    it "summarizes text using the OpenAI client" do
      expect(client).to receive(:summarize).with(text: "test text")
      llm.summarize("test text")
    end
  end

  describe "#chat" do
    it "chats using the OpenAI client" do
      messages = [{role: "user", content: "Hello"}]
      expect(client).to receive(:chat).with(messages: messages)
      llm.chat(messages)
    end
  end

  describe "#rag_chat" do
    let(:query) { "What's new with Project X?" }
    let(:messages) { [{role: "user", content: query}] }
    let(:context) { "Project X launched a new feature yesterday." }
    let(:retrieved_messages) { [double(content: context)] }

    before do
      allow(database).to receive(:query_messages).and_return(retrieved_messages)
    end

    it "retrieves context and enhances messages before chatting" do
      expect(database).to receive(:query_messages).with(query, limit: 5).and_return(retrieved_messages)
      
      expected_messages = [
        { role: "system", content: "You are a helpful assistant with knowledge about various crypto projects and potential airdrops. Use the following context to inform your responses, but don't directly reference it unless necessary: #{context}" },
        *messages
      ]
      
      expect(client).to receive(:chat).with(messages: expected_messages)
      
      llm.rag_chat(query, messages)
    end

    it "allows customizing the number of results" do
      expect(database).to receive(:query_messages).with(query, limit: 3).and_return(retrieved_messages)
      expect(client).to receive(:chat)
      
      llm.rag_chat(query, messages, num_results: 3)
    end
  end
end