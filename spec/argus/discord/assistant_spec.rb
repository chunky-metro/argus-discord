# frozen_string_literal: true

require "spec_helper"

RSpec.describe Argus::Discord::Assistant do
  let(:database) { instance_double(Argus::Discord::Database) }
  let(:llm) { instance_double(Argus::Discord::LLM) }
  let(:importance_calculator) { instance_double(Argus::Discord::DefaultImportanceCalculator) }
  let(:message_fetcher) { instance_double(Argus::Discord::DefaultMessageFetcher) }
  let(:assistant) { described_class.new(database, llm, importance_calculator: importance_calculator, message_fetcher: message_fetcher) }

  describe "#initialize" do
    it "sets up the assistant with correct dependencies" do
      expect(assistant.database).to eq(database)
      expect(assistant.llm).to eq(llm)
      expect(assistant.importance_calculator).to eq(importance_calculator)
      expect(assistant.message_fetcher).to eq(message_fetcher)
    end
  end

  describe "#process_message" do
    it "processes a message and returns importance" do
      message = instance_double("Discordrb::Message", content: "Test message")
      embedding = [0.1, 0.2, 0.3]
      expect(llm).to receive(:embed).with("Test message").and_return(embedding)
      expect(importance_calculator).to receive(:calculate).with(embedding).and_return(0.7)
      expect(assistant.process_message(message)).to eq(0.7)
    end
  end

  describe "#generate_summary" do
    it "generates a summary for a given time range" do
      expect(message_fetcher).to receive(:fetch).with(:daily).and_return(["Message 1", "Message 2"])
      expect(llm).to receive(:summarize).with("Message 1\nMessage 2").and_return("Summary")
      expect(assistant.generate_summary).to eq("Summary")
    end
  end

  describe "#answer_question" do
    it "answers a question based on relevant messages" do
      expect(database).to receive(:query_messages).with("test question").and_return([double(content: "Relevant content")])
      expect(llm).to receive(:chat).with(array_including(hash_including(role: "system"), hash_including(role: "user"))).and_return("Answer")
      expect(assistant.answer_question("test question")).to eq("Answer")
    end
  end
end