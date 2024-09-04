# frozen_string_literal: true

require "discordrb"
require_relative "config"
require_relative "database"
require_relative "llm"
require_relative "assistant"
require_relative "embedding_service"
require_relative "handler_service"

module Argus
  module Discord
    class Bot
      attr_reader :bot, :database, :llm, :assistant, :embedding_service, :handlers

      def initialize
        @bot = Discordrb::Bot.new(token: Config.discord_bot_token)
        @database = Database.new
        @llm = LLM.new
        @assistant = Assistant.new(database, llm)
        @embedding_service = EmbeddingService.new(database)
        @handlers = HandlerService.new(bot, database, assistant, embedding_service)
      end

      def run
        Logger.info("Starting Argus Discord bot...")
        handlers.setup
        bot.run
      end

      def shutdown
        Logger.info("Shutting down Argus Discord bot...")
        bot.stop
      end
    end
  end
end