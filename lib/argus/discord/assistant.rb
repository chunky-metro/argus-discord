# frozen_string_literal: true

require "openai"
require_relative "config"

module Argus
  module Discord
    class Assistant
      attr_reader :database, :llm

      def initialize(database)
        @database = database
        @llm = OpenAI::Client.new(access_token: Config.openai_api_key)
      end

      def process_message(content)
        importance = calculate_importance(content)
        importance == :critical ? :critical : :normal
      rescue => e
        puts "Error processing message: #{e.message}"
        puts e.backtrace.join("\n")
        :normal
      end

      def generate_daily_summary
        start_time = Time.now - 24 * 60 * 60  # 24 hours ago
        end_time = Time.now
        messages = database.get_messages_for_date_range(start_time, end_time)
        
        return nil if messages.empty?

        prompt = "Summarize the following Discord messages from all channels in the last 24 hours:\n\n"
        messages.each do |msg|
          prompt += "#{Time.at(msg['timestamp']).strftime('%Y-%m-%d %H:%M:%S')} - Channel: #{msg['channel_id']} - #{msg['content']}\n"
        end
        prompt += "\nProvide a concise summary of the key points and any important announcements across all channels."

        response = llm.chat(
          parameters: {
            model: "gpt-3.5-turbo",
            messages: [{ role: "user", content: prompt }],
            temperature: 0.7,
            max_tokens: 500
          }
        )

        response.dig("choices", 0, "message", "content")
      rescue => e
        puts "Error generating daily summary: #{e.message}"
        puts e.backtrace.join("\n")
        nil
      end

      private

      def calculate_importance(content)
        prompt = "Analyze the following message and determine if it contains critically important information that requires immediate attention. Respond with 'CRITICAL' if it's critically important, or 'NORMAL' otherwise.\n\nMessage: #{content}"

        response = llm.chat(
          parameters: {
            model: "gpt-3.5-turbo",
            messages: [{ role: "user", content: prompt }],
            temperature: 0.3,
            max_tokens: 10
          }
        )

        result = response.dig("choices", 0, "message", "content").to_s.strip.upcase
        result == "CRITICAL" ? :critical : :normal
      end
    end
  end
end