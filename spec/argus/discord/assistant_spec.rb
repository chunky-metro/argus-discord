# frozen_string_literal: true

require "spec_helper"

RSpec.describe Argus::Discord::Assistant do
  let(:database) { instance_double(Argus::Discord::Database) }
  let(:llm) { instance_double(OpenAI::Client) }
  let(:assistant) { described_class.new(database) }

  before do
    allow(OpenAI::Client).to receive(:new).and_return(llm)
  end

  describe "#initialize" do
    it "sets up the assistant with correct dependencies" do
      expect(assistant.database).to eq(database)
      expect(assistant.llm).to eq(llm)
    end
  end

  describe "#process_message" do
    context "when the message is not critical" do
      it "returns :normal" do
        allow(assistant).to receive(:calculate_importance).and_return(:normal)
        expect(assistant.process_message("Hello, world!")).to eq(:normal)
      end
    end

    context "when the message is critical" do
      it "returns :critical" do
        allow(assistant).to receive(:calculate_importance).and_return(:critical)
        expect(assistant.process_message("URGENT: System failure!")).to eq(:critical)
      end
    end

    context "when an error occurs" do
      it "returns :normal and logs the error" do
        allow(assistant).to receive(:calculate_importance).and_raise(StandardError.new("Test error"))
        expect(assistant.process_message("Test message")).to eq(:normal)
        expect { assistant.process_message("Test message") }.to output(/Error processing message: Test error/).to_stdout
      end
    end
  end

  describe "#generate_daily_summary" do
    let(:messages) do
      [
        { "timestamp" => Time.now.to_i, "channel_id" => "123", "content" => "Hello" },
        { "timestamp" => Time.now.to_i, "channel_id" => "456", "content" => "World" }
      ]
    end

    context "when there are messages" do
      before do
        allow(database).to receive(:get_messages_for_date_range).and_return(messages)
        allow(llm).to receive(:chat).and_return({ "choices" => [{ "message" => { "content" => "Summary" } }] })
      end

      it "generates a summary" do
        expect(assistant.generate_daily_summary).to eq("Summary")
      end
    end

    context "when there are no messages" do
      before do
        allow(database).to receive(:get_messages_for_date_range).and_return([])
      end

      it "returns nil" do
        expect(assistant.generate_daily_summary).to be_nil
      end
    end

    context "when an error occurs" do
      before do
        allow(database).to receive(:get_messages_for_date_range).and_raise(StandardError.new("Test error"))
      end

      it "returns nil and logs the error" do
        expect(assistant.generate_daily_summary).to be_nil
        expect { assistant.generate_daily_summary }.to output(/Error generating daily summary: Test error/).to_stdout
      end
    end
  end
end