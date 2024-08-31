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
    it "processes a message and returns embedding and importance" do
      message = instance_double("Discordrb::Message", content: "Test message")
      embedding = [0.1, 0.2, 0.3]
      expect(llm).to receive(:embed).with("Test message").and_return(embedding)
      expect(importance_calculator).to receive(:calculate).with(embedding).and_return(0.7)
      expect(database).to receive(:save_message).with(message)
      expect(assistant.process_message(message)).to eq({embedding: embedding, importance: 0.7})
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
    it "answers a question using RAG chat" do
      question = "What is the latest update on Project X?"
      expected_messages = [
        {role: "system", content: "You are a helpful assistant that answers questions about crypto projects and potential airdrops based on the given context."},
        {role: "user", content: question}
      ]
      expect(llm).to receive(:rag_chat).with(question, expected_messages).and_return("Answer about Project X")
      expect(assistant.answer_question(question)).to eq("Answer about Project X")
    end
  end

  describe "#analyze_project_update" do
    it "analyzes a project update and provides insights" do
      project_name = "Project Y"
      update_content = "Project Y has launched a new feature"
      query = "Latest updates about Project Y"
      expected_messages = [
        {role: "system", content: "You are an expert in analyzing crypto projects and identifying potential airdrop opportunities. Analyze the following update and provide insights on its importance and any potential airdrop implications."},
        {role: "user", content: "Project: Project Y\nUpdate: Project Y has launched a new feature"}
      ]
      expect(llm).to receive(:rag_chat).with(query, expected_messages).and_return("Analysis of Project Y update")
      expect(assistant.analyze_project_update(project_name, update_content)).to eq("Analysis of Project Y update")
    end
  end
end