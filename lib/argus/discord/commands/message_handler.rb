# frozen_string_literal: true

module Argus
    module Discord
      module Commands
        class MessageHandler
          attr_reader :database, :assistant

          def initialize(database, assistant)
            @database = database
            @assistant = assistant
          end
  
          def call(event)
            @database.save_message(event.message)
            importance = @assistant.process_message(event.message)
            notify_if_important(event, importance)
          end
  
          private
  
          def notify_if_important(event, importance)
            return unless importance > 0.8
            event.respond("⚠️ Important announcement detected! ⚠️\n#{event.message.content}")
          end
        end
      end
    end
  end