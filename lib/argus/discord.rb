# frozen_string_literal: true

require_relative "discord/version"
require_relative "discord/bot"
require_relative "discord/database"
require_relative "discord/llm"
require_relative "discord/logger"
require_relative "discord/assistant"

module Argus
  module Discord
    class Error < StandardError; end

    def self.run
      Bot.new.run
    end
  end
end