namespace :weaviate do
  desc "Run Weaviate migrations"
  task :migrate do
    require_relative "../../db/migrations/20230401000000_create_discord_messages"

    puts "Running Weaviate migration: CreateDiscordMessages"
    CreateDiscordMessages.up
    puts "Migration completed successfully"
  end

  desc "Rollback Weaviate migrations"
  task :rollback do
    require_relative "../../db/migrations/20230401000000_create_discord_messages"

    puts "Rolling back Weaviate migration: CreateDiscordMessages"
    CreateDiscordMessages.down
    puts "Rollback completed successfully"
  end
end