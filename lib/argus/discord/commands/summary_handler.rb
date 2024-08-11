# frozen_string_literal: true

module Argus
  module Discord
    module Commands
      class SummaryHandler
        attr_reader :assistant

        def initialize(assistant)
          @assistant = assistant
        end

        def call(event)
          summary = assistant.generate_summary
          event.respond(summary)
        end
      end
    end
  end
end