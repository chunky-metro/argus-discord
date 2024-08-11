# frozen_string_literal: true

require "discordrb"
require_relative "commands/message_handler"
require_relative "commands/summary_handler"
require_relative "commands/question_handler"

module Argus
  module Discord
    class Bot
      attr_reader :client, :database, :llm, :assistant

      def initialize(client: nil, database: nil, llm: nil, assistant: nil)
        @client = client || Discordrb::Bot.new(token: ENV["DISCORD_BOT_TOKEN"])
        @database = database || Database.new
        @llm = llm || LLM.new
        @assistant = assistant || Assistant.new(@database, @llm)
        @message_handler = Commands::MessageHandler.new(@database, @assistant)
        @summary_handler = Commands::SummaryHandler.new(@assistant)
        @question_handler = Commands::QuestionHandler.new(@assistant)
        setup_handlers
      end

      def run
        @client.run
      end

      private

      attr_reader :message_handler, :summary_handler, :question_handler

      def setup_handlers
        @client.message(&method(:handle_message))
        @client.message(start_with: "!summary", &summary_handler.method(:call))
        @client.message(start_with: "!ask", &question_handler.method(:call))
      end

      def handle_message(event)
        message_handler.call(event)
      end
    end
  end
end