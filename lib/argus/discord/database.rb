# frozen_string_literal: true

require "weaviate"
require "langchain"

module Argus
  module Discord
    class Database
      attr_reader :client

      def initialize(client: nil)
        @client = client || Langchain::Vectorsearch::Weaviate.new(
          url: ENV["WEAVIATE_URL"],
          api_key: ENV["WEAVIATE_API_KEY"],
          index_name: "DiscordMessages"
        )
        create_schema
      end

      def save_message(message)
        client.add_texts([message.content], metadata: message_metadata(message))
      end

      def query_messages(query, limit: 10)
        client.similarity_search(query, k: limit)
      end

      private

      def message_metadata(message)
        {
          channel_id: message.channel.id,
          message_id: message.id,
          created_at: message.timestamp.to_i
        }
      end

      def create_schema
        client.create_schema(
          class_name: "DiscordMessage",
          properties: [
            {name: "content", data_type: ["text"]},
            {name: "channel_id", data_type: ["int"]},
            {name: "message_id", data_type: ["int"]},
            {name: "created_at", data_type: ["int"]}
          ]
        )
      end
    end
  end
end