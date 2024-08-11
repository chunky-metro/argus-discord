# frozen_string_literal: true

require "spec_helper"

RSpec.describe Argus::Discord::Commands::QuestionHandler do
  let(:assistant) { instance_double(Argus::Discord::Assistant) }
  let(:handler) { described_class.new(assistant) }

  describe "#initialize" do
    it "sets up the handler with correct dependencies" do
      expect(handler.assistant).to eq(assistant)
    end
  end

  describe "#call" do
    let(:event) { instance_double(Discordrb::Events::MessageEvent) }
    let(:message) { instance_double(Discordrb::Message, content: "!ask What is the meaning of life?") }

    before do
      allow(event).to receive(:message).and_return(message)
    end

    it "answers the question and responds to the event" do
      expect(assistant).to receive(:answer_question).with("What is the meaning of life?").and_return("42")
      expect(event).to receive(:respond).with("42")
      handler.call(event)
    end
  end
end