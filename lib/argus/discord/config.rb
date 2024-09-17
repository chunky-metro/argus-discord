# frozen_string_literal: true

require "dotenv"

module Argus
  module Discord
    class Config
      class << self
        def discord_bot_token
          ENV.fetch("DISCORD_BOT_TOKEN") { raise "ENV['DISCORD_BOT_TOKEN'] is not set" }
        end

        def openai_api_key
          ENV.fetch("OPENAI_API_KEY") { raise "ENV['OPENAI_API_KEY'] is not set" }
        end

        def openai_assistant_id
          ENV.fetch("OPENAI_ASSISTANT_ID") { raise "ENV['OPENAI_ASSISTANT_ID'] is not set" }
        end

        def openai_vector_store_id
          ENV.fetch("OPENAI_VECTOR_STORE_ID") { raise "ENV['OPENAI_VECTOR_STORE_ID'] is not set" }
        end
        
        def root_path
          @root_path ||= File.expand_path('../../..', __dir__)
        end
      end
    end
  end
end