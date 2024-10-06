require 'spec_helper'

RSpec.describe Argus::Discord::Message do
  let(:message_event) do
    {
      "d" => {
        "author" => { "username" => "test_user" },
        "timestamp" => "2024-09-18T06:46:18.335000+00:00",
        "content" => "Hello, world!"
      }
    }
  end

  describe '.for' do
    it 'returns MessageWithAttachment for messages with attachments' do
      message_event["d"]["attachments"] = [{}]
      expect(described_class.for(message_event)).to be_a(Argus::Discord::MessageWithAttachment)
    end

    it 'returns MessageWithEmbed for messages with embeds' do
      message_event["d"]["embeds"] = [{}]
      expect(described_class.for(message_event)).to be_a(Argus::Discord::MessageWithEmbed)
    end

    it 'returns Message for messages without attachments or embeds' do
      expect(described_class.for(message_event)).to be_a(Argus::Discord::Message)
    end
  end

  describe '#call' do
    subject { described_class.new(message_event).call }

    it 'returns a markdown string' do
      expect(subject).to be_a(String)
      expect(subject).to include('# Message')
    end

    it 'includes the author username' do
      expect(subject).to include('**Author:** test_user')
    end

    it 'includes the timestamp' do
      expect(subject).to include('**Timestamp:** 2024-09-18T06:46:18.335000+00:00')
    end

    it 'includes the content' do
      expect(subject).to include('**Content:**')
      expect(subject).to include('Hello, world!')
    end
  end
end