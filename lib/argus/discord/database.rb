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

      def store_message(content:, author:, channel:, timestamp:, guild:)
        client.objects.create(
          class_name: "DiscordMessage",
          properties: {
            content: content,
            author: author,
            channel: channel,
            timestamp: timestamp,
            guild: guild
          }
        )
      end

      def query_messages(query, limit: 5)
        client.objects.get(
          class_name: "DiscordMessage",
          fields: ["content", "author", "channel", "timestamp", "guild"],
          where: {
            operator: "And",
            operands: [
              {
                path: ["content"],
                operator: "Like",
                valueString: query
              }
            ]
          },
          limit: limit
        )
      end
    end
  end
end