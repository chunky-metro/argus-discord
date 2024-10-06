module Argus
  module Discord
    class Message
      def self.for(message_event)
        if message_event["d"]["attachments"]&.any?
          MessageWithAttachment.new(message_event)
        elsif message_event["d"]["embeds"]&.any?
          MessageWithEmbed.new(message_event)
        else
          new(message_event)
        end
      end

      def initialize(message_event)
        @message_event = message_event
      end

      def call
        message_data = @message_event["d"]
        
        markdown = "# Message\n\n"
        markdown += "**Author:** #{message_data['author']['username']}\n"
        markdown += "**Timestamp:** #{message_data['timestamp']}\n\n"
        markdown += "**Content:**\n#{message_data['content']}\n\n" unless message_data['content'].empty?

        markdown
      end
    end
  end
end
