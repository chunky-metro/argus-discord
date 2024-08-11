# frozen_string_literal: true

require "spec_helper"

RSpec.describe Argus::Discord::LLM do
  let(:llm) { described_class.new }

  describe "#initialize" do
    it "sets up the OpenAI client" do
      expect(llm.client).to be_a(Langchain::LLM::OpenAI)
    end
  end

  describe "#embed" do
    it "embeds text using the OpenAI client" do
      expect(llm.client).to receive(:embed).with("test text")
      llm.embed("test text")
    end
  end

  describe "#summarize" do
    it "summarizes text using the OpenAI client" do
      expect(llm.client).to receive(:summarize).with("test text")
      llm.summarize("test text")
    end
  end

  describe "#chat" do
    it "chats using the OpenAI client" do
      messages = [{role: "user", content: "Hello"}]
      expect(llm.client).to receive(:chat).with(messages: messages)
      llm.chat(messages)
    end
  end
end