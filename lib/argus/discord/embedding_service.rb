# frozen_string_literal: true

require "langchain"
require_relative "config"

module Argus
  module Discord
    class EmbeddingService
      attr_reader :database, :embedder

      def initialize(database)
        @database = database
        @embedder = Langchain::LLM::OpenAI.new(api_key: Config.openai_api_key)
      end

      def embed_and_store_message(message)
        embedding = embedder.embed(text: message.content)
        database.store_message(
          content: message.content,
          author: message.author.username,
          channel: message.channel.name,
          timestamp: message.timestamp.to_s,
          guild: message.server.name,
          embedding: embedding
        )
      end
    end
  end
end