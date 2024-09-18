require 'spec_helper'

RSpec.describe Argus::Discord::MessageWithEmbed do
  let(:message_event) do
    {
      "d" => {
        "author" => { "username" => "test_user" },
        "timestamp" => "2024-09-18T06:46:18.335000+00:00",
        "content" => "https://x.com/PixSorcerer/status/1836199484889665717",
        "embeds" => [{
          "title" => "Pix🔎 (@PixSorcerer) on X",
          "description" => "This is Professor Crypto",
          "url" => "https://twitter.com/PixSorcerer/status/1836199484889665717",
          "color" => 1942002,
          "image" => {
            "url" => "https://pbs.twimg.com/media/GXt9sgBakAADHNV.jpg:large",
            "width" => 913,
            "height" => 993
          },
          "footer" => {
            "text" => "Twitter",
            "icon_url" => "https://abs.twimg.com/icons/apple-touch-icon-192x192.png"
          }
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
      expect(result).to include('**Timestamp:** 2024-09-18T06:46:18.335000+00:00')
    end

    it 'includes the content' do
      expect(result).to include('**Content:**')
      expect(result).to include('https://x.com/PixSorcerer/status/1836199484889665717')
    end

    it 'includes embed details' do
      expect(result).to include('**Embed:**')
      expect(result).to include('**Title:** Pix🔎 (@PixSorcerer) on X')
      expect(result).to include('**Description:** This is Professor Crypto')
      expect(result).to include('**URL:** https://twitter.com/PixSorcerer/status/1836199484889665717')
      expect(result).to include('**Color:** 1942002')
    end

    it 'includes image details' do
      expect(result).to include('**Image:**')
      expect(result).to include('**URL:** https://pbs.twimg.com/media/GXt9sgBakAADHNV.jpg:large')
      expect(result).to include('**Width:** 913')
      expect(result).to include('**Height:** 993')
    end

    it 'includes footer details' do
      expect(result).to include('**Footer:**')
      expect(result).to include('**Text:** Twitter')
      expect(result).to include('**Icon URL:** https://abs.twimg.com/icons/apple-touch-icon-192x192.png')
    end
  end
end