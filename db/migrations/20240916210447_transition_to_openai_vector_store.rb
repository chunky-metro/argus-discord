require "openai"

class TransitionToOpenAIVectorStore
  def self.up
    # Remove Weaviate schema (if it exists)
    begin
      client = Argus::Clients::Weaviate.client
      client.schema.delete(class_name: "DiscordAnnouncementMessage")
    rescue StandardError => e
      puts "Error removing Weaviate schema: #{e.message}"
    end

    # Set up OpenAI vector store
    openai_client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
    vector_store = openai_client.files.create_vector_store(
      name: "discord_messages",
      description: "Vector store for Discord messages"
    )

    # Store the vector store ID in a configuration file or database
    File.write("config/openai_vector_store_id.txt", vector_store.id)
  end

  def self.down
    # Remove OpenAI vector store
    openai_client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
    vector_store_id = File.read("config/openai_vector_store_id.txt").strip
    openai_client.files.delete(id: vector_store_id)

    # Remove the stored vector store ID
    File.delete("config/openai_vector_store_id.txt")

    # Recreate Weaviate schema (if needed)
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
end