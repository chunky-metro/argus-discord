require "weaviate"

class CreateDiscordMessages
  def self.up
    client = Weaviate::Client.new(
      url: ENV["WEAVIATE_URL"],
      api_key: ENV["WEAVIATE_API_KEY"]
    )

    schema = {
      class: "DiscordMessage",
      properties: [
        { name: "content", dataType: ["text"] },
        { name: "author", dataType: ["string"] },
        { name: "channel", dataType: ["string"] },
        { name: "timestamp", dataType: ["date"] },
        { name: "guild", dataType: ["string"] }
      ],
      vectorizer: "text2vec-openai"
    }

    client.schema.create_class(schema)
  end

  def self.down
    client = Weaviate::Client.new(
      url: ENV["WEAVIATE_URL"],
      api_key: ENV["WEAVIATE_API_KEY"]
    )

    client.schema.delete_class("DiscordMessage")
  end
end