# frozen_string_literal: true

require "langchain"

module Argus
  module Discord
    class LLM
      attr_reader :client

      def initialize
        @client = Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"])
      end

      def embed(text)
        client.embed(text)
      end

      def summarize(text)
        client.summarize(text)
      end

      def chat(messages)
        client.chat(messages: messages)
      end
    end
  end
end