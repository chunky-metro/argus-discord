# frozen_string_literal: true

require "discordrb"
require "date"
require_relative "config"
require_relative "database"
require_relative "assistant"

module Argus
  module Discord
    class Bot
      attr_reader :bot, :database, :assistant

      def initialize
        @bot = Discordrb::Bot.new(token: Config.discord_bot_token)
        puts "This bot's invite URL is #{bot.invite_url}"
        puts 'Click on it to invite it to your server.'
        @database = Database.new
        @assistant = Assistant.new(@database)
      end

      def run
        setup_message_handler
        setup_daily_summary
        bot.run
      end

      private

      def setup_message_handler
        bot.message do |event|
          begin
            # Save every message
            database.save_message(event)

            # Process the message with the assistant
            importance = assistant.process_message(event.content)

            if importance == :critical
              event.respond("@here Critical information detected: #{event.content}")
            end
          rescue => e
            puts "Error processing message: #{e.message}"
            puts e.backtrace.join("\n")
          end
        end
      end

      def setup_daily_summary
        Thread.new do
          loop do
            sleep_until_next_day
            generate_summary
          end
        end
      end

      def generate_summary
        argus_channel = bot.find_channel("argus")
        if argus_channel
          begin
            summary = assistant.generate_daily_summary
            argus_channel.send_message(summary) if summary
          rescue => e
            puts "Error generating summary for #argus channel: #{e.message}"
            puts e.backtrace.join("\n")
          end
        else
          puts "Error: #argus channel not found"
        end
      end

      def sleep_until_next_day
        tomorrow = Date.today + 1
        seconds_until_tomorrow = (tomorrow.to_time - Time.now).to_i
        sleep(seconds_until_tomorrow)
      end
    end
  end
end