# frozen_string_literal: true

require "logger"

module Argus
  module Discord
    class Logger
      class << self
        def logger
          @logger ||= ::Logger.new($stdout)
        end

        def method_missing(method_name, *args, &block)
          if logger.respond_to?(method_name)
            logger.send(method_name, *args, &block)
          else
            super
          end
        end

        def respond_to_missing?(method_name, include_private = false)
          logger.respond_to?(method_name) || super
        end
      end
    end
  end
end