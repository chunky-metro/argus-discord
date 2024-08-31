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
        importance = importance_calculator.calculate(embedding)
        database.save_message(message)
        {embedding: embedding, importance: importance}
      end

      def generate_summary(time_range: :daily)
        messages = message_fetcher.fetch(time_range)
        llm.summarize(messages.join("\n"))
      end

      def answer_question(question)
        llm.rag_chat(question, [
          {role: "system", content: "You are a helpful assistant that answers questions about crypto projects and potential airdrops based on the given context."},
          {role: "user", content: question}
        ])
      end

      def analyze_project_update(project_name, update_content)
        query = "Latest updates about #{project_name}"
        llm.rag_chat(query, [
          {role: "system", content: "You are an expert in analyzing crypto projects and identifying potential airdrop opportunities. Analyze the following update and provide insights on its importance and any potential airdrop implications."},
          {role: "user", content: "Project: #{project_name}\nUpdate: #{update_content}"}
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