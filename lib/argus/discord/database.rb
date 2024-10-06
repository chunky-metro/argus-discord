# frozen_string_literal: true

require "openai"
require "json"
require_relative "config"

module Argus
  module Discord
    class Database
      attr_reader :client

      def initialize
        @client = OpenAI::Client.new(access_token: Config.openai_api_key)
      end

      def create(message_event)
        file = upload(Argus::Discord::Message.new(message_event))

        vector_store_file = client.vector_store_files.create(
          vector_store_id: Config.openai_vector_store_id,
          parameters: { file_id: file["id"] }
        )

        vector_store_file
      end

    private

      def upload(message)
        temp_file = Tempfile.new(['upload', '.md'])
        begin
          temp_file.write(message)
          temp_file.rewind

          client.files.upload(
            parameters: { file: temp_file.path, purpose: "assistants" }
          )
        rescue
          Logger.error("Could not upload file")
        ensure
          temp_file.close
          temp_file.unlink
        end
      end
    end
  end
end