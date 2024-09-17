# frozen_string_literal: true

require "dotenv"

module Argus
  module Discord
    class Config
      class << self

        def discord_bot_token
          ENV["DISCORD_BOT_TOKEN"]
        end

        def openai_api_key
          ENV["OPENAI_API_KEY"]
        end

        def weaviate_url
          ENV["WEAVIATE_URL"]
        end

        def weaviate_api_key
          ENV["WEAVIATE_API_KEY"]
        end

      end
    end
  end
end