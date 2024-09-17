# frozen_string_literal: true

require "weaviate"
require "dotenv/load"

module Argus
  module Clients
    class Weaviate
      def self.client
        ::Weaviate::Client.new(
          url: ENV["WEAVIATE_URL"],
          api_key: ENV["WEAVIATE_API_KEY"],
          model_service: ENV.fetch("WEAVIATE_MODEL_SERVICE", :openai),
          model_service_api_key: ENV.fetch("WEAVIATE_MODEL_API_KEY", ENV["OPENAI_API_KEY"])
        )
      end
    end
  end
end