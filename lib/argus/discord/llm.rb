# frozen_string_literal: true

require "langchain"

module Argus
  module Discord
    class LLM
      attr_reader :client, :embedder, :database

      def initialize(client: nil, embedder: nil, database: nil)
        @client = client || Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"])
        @embedder = embedder || @client
        @database = database || Database.new
      end

      def embed(text)
        embedder.embed(text: text)
      end

      def summarize(text)
        client.summarize(text: text)
      end

      def chat(messages)
        client.chat(messages: messages)
      end

      def rag_chat(query, messages, num_results: 5)
        context = retrieve_context(query, num_results)
        enhanced_messages = [
          { role: "system", content: "You are a helpful assistant with knowledge about various crypto projects and potential airdrops. Use the following context to inform your responses, but don't directly reference it unless necessary: #{context}" },
          *messages
        ]
        chat(enhanced_messages)
      end

      private

      def retrieve_context(query, num_results)
        results = database.query_messages(query, limit: num_results)
        results.map { |result| result.content }.join("\n\n")
      end
    end
  end
end