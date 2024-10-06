# frozen_string_literal: true

require 'spec_helper'
require 'argus/discord/bot'
require 'argus/discord/database'
require 'argus/discord/assistant'

RSpec.describe Argus::Discord::Bot do
  describe '#run' do
    context 'when processing a normal message' do
      before do
        allow(event).to receive(:content).and_return('Hello, world!')
        allow(assistant).to receive(:process_message).and_return(:normal)
      end

      it 'saves the message and processes it without responding' do
        expect(database).to receive(:save_message).with(instance_double(Discordrb::Message))
        expect(assistant).to receive(:process_message).with('Hello, world!')
        expect(event).not_to receive(:respond)

        subject.run
      end
    end

    context 'when processing a critical message' do
      before do
        allow(event).to receive(:content).and_return('URGENT: System failure!')
        allow(assistant).to receive(:process_message).and_return(:critical)
      end

      it 'saves the message, processes it, and responds with a critical alert' do
        expect(database).to receive(:save_message).with(123, 456, 'URGENT: System failure!')
        expect(assistant).to receive(:process_message).with('URGENT: System failure!')
        expect(event).to receive(:respond).with('@here Critical information detected: URGENT: System failure!')

        subject.run
      end
    end
  end
end