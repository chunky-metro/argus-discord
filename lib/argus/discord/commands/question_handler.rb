# frozen_string_literal: true

module Argus
  module Discord
    module Commands
      class QuestionHandler
        attr_reader :assistant

        def initialize(assistant)
          @assistant = assistant
        end

        def call(event)
          question = event.message.content.sub("!ask ", "")
          answer = @assistant.answer_question(question)
          event.respond(answer)
        end
      end
    end
  end
end