# frozen_string_literal: true

require "weaviate"
require_relative "config"

module Argus
  module Discord
    class Database
      attr_reader :client

      def initialize
        @client = Weaviate::Client.new(
          url: Config.weaviate_url,
          api_key: Config.weaviate_api_key
        )
      end

      def save_message(channel_id, author_id, content)
        client.objects.create(
          class_name: "DiscordMessage",
          properties: {
            content: content,
            channel_id: channel_id,
            author_id: author_id,
            timestamp: Time.now.to_i
          }
        )
      end

      def get_messages_for_date_range(channel_id, start_time, end_time)
        client.objects.get(
          class_name: "DiscordMessage",
          fields: ["content", "author_id", "timestamp"],
          where: {
            operator: "And",
            operands: [
              {
                path: ["channel_id"],
                operator: "Equal",
                valueString: channel_id
              },
              {
                path: ["timestamp"],
                operator: "GreaterThanEqual",
                valueInt: start_time.to_i
              },
              {
                path: ["timestamp"],
                operator: "LessThan",
                valueInt: end_time.to_i
              }
            ]
          }
        )
      end

      def search_similar_messages(content, limit: 5)
        client.objects.get(
          class_name: "DiscordMessage",
          fields: ["content", "author_id", "timestamp"],
          near_text: { concepts: [content] },
          limit: limit
        )
      end
    end
  end
end