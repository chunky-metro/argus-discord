# frozen_string_literal: true

require "spec_helper"

RSpec.describe Argus::Discord::Bot do
  let(:client) { instance_double(Discordrb::Bot) }
  let(:database) { instance_double(Argus::Discord::Database) }
  let(:assistant) { instance_double(Argus::Discord::Assistant) }
  let(:bot) { described_class.new(client: client, token: "test_token", database: database, assistant: assistant) }

  describe "#initialize" do
    it "sets up the bot with correct dependencies" do
      expect(bot.client).to eq(client)
      expect(bot.database).to eq(database)
      expect(bot.assistant).to eq(assistant)
    end

    it "initializes command handlers" do
      expect(client).to receive(:message).at_least(:once)
      described_class.new(client: client, token: "test_token", database: database, assistant: assistant)
    end
  end

  describe "#run" do
    it "runs the Discord client" do
      expect(client).to receive(:run)
      bot.run
    end
  end
end