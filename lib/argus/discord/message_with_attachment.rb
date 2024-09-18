module Argus
  module Discord
    class MessageWithAttachment < Message
      def call
        markdown = super
        
        attachment = @message_event["d"]["attachments"].first
        markdown += "**Attachment:**\n"
        markdown += "- **Filename:** #{attachment['filename']}\n"
        markdown += "- **Content Type:** #{attachment['content_type']}\n"
        markdown += "- **Size:** #{attachment['size']} bytes\n"
        markdown += "- **Dimensions:** #{attachment['width']}x#{attachment['height']}\n"
        markdown += "- **URL:** #{attachment['url']}\n"

        markdown
      end
    end
  end
end