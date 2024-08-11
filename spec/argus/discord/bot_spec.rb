# frozen_string_literal: true

require "spec_helper"

RSpec.describe Argus::Discord::Bot do
  let(:client) { instance_double(Discordrb::Bot) }
  let(:database) { instance_double(Argus::Discord::Database) }
  let(:llm) { instance_double(Argus::Discord::LLM) }
  let(:assistant) { instance_double(Argus::Discord::Assistant) }
  let(:bot) { described_class.new(client: client, database: database, llm: llm, assistant: assistant) }

  describe "#initialize" do
    it "sets up the bot with correct dependencies" do
      expect(bot.client).to eq(client)
      expect(bot.database).to eq(database)
      expect(bot.llm).to eq(llm)
      expect(bot.assistant).to eq(assistant)
    end

    it "initializes command handlers" do
      expect(bot.send(:message_handler)).to be_a(Argus::Discord::Commands::MessageHandler)
      expect(bot.send(:summary_handler)).to be_a(Argus::Discord::Commands::SummaryHandler)
      expect(bot.send(:question_handler)).to be_a(Argus::Discord::Commands::QuestionHandler)
    end
  end

  describe "#run" do
    it "runs the Discord client" do
      expect(client).to receive(:run)
      bot.run
    end
  end
end