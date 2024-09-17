require "argus/clients/weaviate"

class NilClass
  def present?
    false
  end
end

class CreateDiscordMessages
  def self.up
    client = Argus::Clients::Weaviate.client

    client.schema.create(
      class_name: 'DiscordAnnouncementMessage',
      description: 'A high-signal announcement from a Discord server',
      properties: [
        { name: 'content', dataType: ['text'] },
        { name: 'author', dataType: ['string'] },
        { name: 'channel', dataType: ['string'] },
        { name: 'timestamp', dataType: ['date'] },
        { name: 'guild', dataType: ['string'] }
      ],
      vectorizer: 'text2vec-openai'
    )
  end

  def self.down
    client = Argus::Clients::Weaviate.client

    client.schema.delete(class_name: "DiscordAnnouncementMessage")
  end
end