module Argus
  module Discord
    class MessageWithEmbed < Message
      def call
        markdown = super
        
        embed = @message_event["d"]["embeds"].first
        markdown += "**Embed:**\n"
        markdown += "- **Title:** #{embed['title']}\n"
        markdown += "- **Description:** #{embed['description']}\n"
        markdown += "- **URL:** #{embed['url']}\n"
        markdown += "- **Color:** #{embed['color']}\n"
        if embed['image']
          markdown += "- **Image:**\n"
          markdown += "  - **URL:** #{embed['image']['url']}\n"
          markdown += "  - **Width:** #{embed['image']['width']}\n"
          markdown += "  - **Height:** #{embed['image']['height']}\n"
        end
        if embed['footer']
          markdown += "- **Footer:**\n"
          markdown += "  - **Text:** #{embed['footer']['text']}\n"
          markdown += "  - **Icon URL:** #{embed['footer']['icon_url']}\n"
        end

        markdown
      end
    end
  end
end