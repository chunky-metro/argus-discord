# frozen_string_literal: true

require_relative "database"
require_relative "config"

module Argus
  module Discord
    class EmbeddingService
      attr_reader :database

      def initialize
        @database = Database.new
      end

      def embed_and_store_message(message)
        @database.save_message(message)
      end

      def search_similar_messages(content, limit: 5)
        @database.search_similar_messages(content, limit: limit)
      end

      def get_messages_for_date_range(channel_id, start_time, end_time)
        @database.get_messages_for_date_range(channel_id, start_time, end_time)
      end
    end
  end
end