require 'spec_helper'

RSpec.describe Argus::Discord::MessageWithAttachment do
  let(:message_event) do
    {
      "d" => {
        "author" => { "username" => "test_user" },
        "timestamp" => "2024-09-18T07:20:08.226000+00:00",
        "content" => "",
        "attachments" => [{
          "filename" => "test_image.gif",
          "content_type" => "image/gif",
          "size" => 9516071,
          "url" => "https://cdn.discordapp.com/attachments/1285459567815426068/1285862910912102400/test_image.gif",
          "width" => 1536,
          "height" => 1536
        }]
      }
    }
  end

  subject { described_class.new(message_event) }

  describe '#call' do
    let(:result) { subject.call }

    it 'returns a markdown string' do
      expect(result).to be_a(String)
      expect(result).to include('# Message')
    end

    it 'includes the author username' do
      expect(result).to include('**Author:** test_user')
    end

    it 'includes the timestamp' do
      expect(result).to include('**Timestamp:** 2024-09-18T07:20:08.226000+00:00')
    end

    it 'includes attachment details' do
      expect(result).to include('**Attachment:**')
      expect(result).to include('**Filename:** test_image.gif')
      expect(result).to include('**Content Type:** image/gif')
      expect(result).to include('**Size:** 9516071 bytes')
      expect(result).to include('**Dimensions:** 1536x1536')
      expect(result).to include('**URL:** https://cdn.discordapp.com/attachments/1285459567815426068/1285862910912102400/test_image.gif')
    end
  end
end