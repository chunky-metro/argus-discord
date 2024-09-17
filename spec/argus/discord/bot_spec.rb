# frozen_string_literal: true

require "spec_helper"

RSpec.describe Argus::Discord::Bot do
  let(:bot) { instance_double(Discordrb::Bot) }
  let(:database) { instance_double(Argus::Discord::Database) }
  let(:assistant) { instance_double(Argus::Discord::Assistant) }
  let(:argus_bot) { described_class.new }

  before do
    allow(Discordrb::Bot).to receive(:new).and_return(bot)
    allow(Argus::Discord::Database).to receive(:new).and_return(database)
    allow(Argus::Discord::Assistant).to receive(:new).and_return(assistant)
    allow(bot).to receive(:invite_url).and_return("https://example.com/invite")
    allow(bot).to receive(:run)
    allow(bot).to receive(:message)
  end

  describe "#initialize" do
    it "sets up the bot with correct dependencies" do
      expect(argus_bot.bot).to eq(bot)
      expect(argus_bot.database).to eq(database)
      expect(argus_bot.assistant).to eq(assistant)
    end
  end

  describe "#run" do
    it "sets up message handler and daily summary" do
      expect(argus_bot).to receive(:setup_message_handler)
      expect(argus_bot).to receive(:setup_daily_summary)
      expect(bot).to receive(:run)
      argus_bot.run
    end
  end

  describe "#generate_summary" do
    let(:argus_channel) { instance_double(Discordrb::Channel) }
    let(:summary) { "Daily summary content" }

    before do
      allow(bot).to receive(:find_channel).with("argus").and_return(argus_channel)
      allow(assistant).to receive(:generate_daily_summary).and_return(summary)
      allow(argus_channel).to receive(:send_message)
    end

    it "generates and sends summary only to #argus channel" do
      expect(bot).to receive(:find_channel).with("argus").and_return(argus_channel)
      expect(assistant).to receive(:generate_daily_summary).and_return(summary)
      expect(argus_channel).to receive(:send_message).with(summary)

      argus_bot.send(:generate_summary)
    end

    it "handles missing #argus channel" do
      allow(bot).to receive(:find_channel).with("argus").and_return(nil)
      expect { argus_bot.send(:generate_summary) }.to output(/Error: #argus channel not found/).to_stdout
    end

    it "handles errors during summary generation" do
      allow(assistant).to receive(:generate_daily_summary).and_raise(StandardError, "Test error")
      expect { argus_bot.send(:generate_summary) }.to output(/Error generating summary for #argus channel: Test error/).to_stdout
    end
  end
end