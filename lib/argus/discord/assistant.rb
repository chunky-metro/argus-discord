# frozen_string_literal: true

module Argus
  module Discord
    class Assistant
      attr_reader :database, :llm, :importance_calculator, :message_fetcher

      def initialize(database, llm, importance_calculator: nil, message_fetcher: nil)
        @database = database
        @llm = llm
        @importance_calculator = importance_calculator || DefaultImportanceCalculator.new
        @message_fetcher = message_fetcher || DefaultMessageFetcher.new(@database)
      end

      def process_message(message)
        embedding = llm.embed(message.content)
        importance_calculator.calculate(embedding)
      end

      def generate_summary(time_range: :daily)
        messages = message_fetcher.fetch(time_range)
        llm.summarize(messages.join("\n"))
      end

      def answer_question(question)
        relevant_messages = database.query_messages(question)
        context = relevant_messages.map(&:content).join("\n")
        llm.chat([
          {role: "system", content: "You are a helpful assistant that answers questions based on the given context."},
          {role: "user", content: "Context: #{context}\n\nQuestion: #{question}"}
        ])
      end
    end

    class DefaultImportanceCalculator
      def calculate(embedding)
        # Implement actual logic here
        rand
      end
    end

    class DefaultMessageFetcher
      attr_reader :database

      def initialize(database)
        @database = database
      end

      def fetch(time_range)
        # Implement actual logic here
        []
      end
    end
  end
end