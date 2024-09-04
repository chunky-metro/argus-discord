# frozen_string_literal: true

require_relative "commands/message_handler"
require_relative "commands/summary_handler"
require_relative "commands/question_handler"

module Argus
  module Discord
    class HandlerService
      attr_reader :bot, :database
      
      def initialize(bot, database, assistant, embedding_service)
        @bot = bot

        @message_handler = Commands::MessageHandler.new(database, assistant, embedding_service)
        @summary_handler = Commands::SummaryHandler.new(assistant)
        @question_handler = Commands::QuestionHandler.new(assistant)
      end

      def setup
        bot.message(start_with: "!summary", &@summary_handler.method(:call))
        bot.message(start_with: "!ask", &@question_handler.method(:call))
        bot.message(&method(:handle_message))
        
        Logger.info("Handlers set up successfully")
      end

      private

      def handle_message(event)
        @message_handler.call(event)
      rescue StandardError => e
        Logger.error("Error handling message: #{e.message}")
        Logger.error(e.backtrace.join("\n"))
      end
    end
  end
end