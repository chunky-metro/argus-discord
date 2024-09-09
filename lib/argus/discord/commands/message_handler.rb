# frozen_string_literal: true

module Argus
  module Discord
    module Commands
      class MessageHandler
        attr_reader :database, :assistant, :embedding_service

        def initialize(database, assistant, embedding_service)
          @database = database
          @assistant = assistant
          @embedding_service = embedding_service
        end

        def call(event)
          result = assistant.process_message(event.message)
          notify_if_important(event, result[:importance])
          analyze_project_update(event)
        end

        private

        def notify_if_important(event, importance)
          return unless importance > 0.8
          event.respond("⚠️ Important announcement detected! ⚠️\n#{event.message.content}")
        end

        def analyze_project_update(event)
          project_name = extract_project_name(event.message.content)
          return unless project_name

          analysis = assistant.analyze_project_update(project_name, event.message.content)
          send_analysis(event, project_name, analysis)
        end

        def extract_project_name(content)
          match = content.match(/\b(?:Project|Protocol):\s*(\w+)/i)
          match ? match[1] : nil
        end

        def send_analysis(event, project_name, analysis)
          response = "📊 Project Update Analysis: #{project_name} 📊\n\n#{analysis}"
          event.respond(response)
        end
      end
    end
  end
end