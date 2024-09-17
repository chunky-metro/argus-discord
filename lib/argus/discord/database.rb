# frozen_string_literal: true

require "openai"
require "json"
require_relative "config"

module Argus
  module Discord
    class Database
      attr_reader :client, :vector_store_id

      def initialize
        @client = OpenAI::Client.new(access_token: Config.openai_api_key)

        @vector_store_id = Config.vector_store_id
      end

      def vector_store
        client.vector_stores.retrieve(id: vector_store_id)
      end

      def save_message(message)
        embedding = create_embedding(message.content)
        vector_store.upsert(
          vectors: [{
            id: message.id,
            values: embedding,
            metadata: {
              content: message.content,
              channel_id: message.channel.id,
              author_id: message.author.id,
              author_username: message.author.username,
              timestamp: message.timestamp.to_i,
              edited_timestamp: message.edited_timestamp&.to_i,
              tts: message.tts,
              mention_everyone: message.mention_everyone,
              mentions: message.mentions.map(&:id),
              mention_roles: message.mention_roles,
              attachments: message.attachments.map(&:url),
              embeds: message.embeds.map { |embed| embed_to_hash(embed) }
            }
          }]
        )
      end

      def get_messages_for_date_range(channel_id, start_time, end_time)
        vector_store.query(
          query_embeddings: nil,
          filter: {
            channel_id: { "$eq" => channel_id },
            timestamp: { "$gte" => start_time.to_i, "$lt" => end_time.to_i }
          },
          limit: 1000
        ).matches
      end

      def search_similar_messages(content, limit: 5)
        embedding = create_embedding(content)
        vector_store.query(
          query_embeddings: [embedding],
          limit: limit
        ).matches
      end

      private

      def load_or_create_vector_store
        config_file = File.expand_path(File.join('config', 'openai_vector_store_id.txt'), Config.root_path)
        vector_store_id = read_vector_store_id(config_file)

        if vector_store_id
          client.files.retrieve_vector_store(id: vector_store_id)
        else
          create_new_vector_store(config_file)
        end
      end

      def read_vector_store_id(file_path)
        File.read(file_path).strip
      rescue Errno::ENOENT
        nil
      end

      def create_new_vector_store(config_file)
        new_vector_store = client.files.create_vector_store(
          name: "discord_messages",
          description: "Vector store for Discord messages"
        )
        write_vector_store_id(config_file, new_vector_store.id)
        new_vector_store
      end

      def write_vector_store_id(file_path, id)
        File.write(file_path, id)
      rescue StandardError => e
        puts "Error writing vector store ID to file: #{e.message}"
      end

      def create_embedding(text)
        response = client.embeddings(
          parameters: {
            model: "text-embedding-ada-002",
            input: text
          }
        )
        response.data[0].embedding
      end

      def embed_to_hash(embed)
        {
          title: embed.title,
          type: embed.type,
          description: embed.description,
          url: embed.url,
          timestamp: embed.timestamp&.to_i,
          color: embed.color,
          footer: embed.footer&.to_hash,
          image: embed.image&.to_hash,
          thumbnail: embed.thumbnail&.to_hash,
          author: embed.author&.to_hash,
          fields: embed.fields.map(&:to_hash)
        }
      end
    end
  end
end