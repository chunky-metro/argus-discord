# Argus::Discord

A Discord bot for monitoring announcements and interacting with an LLM using Retrieval Augmented Generation (RAG).

## Features

- Listens to Discord channels and saves messages to OpenAI's vector store
- Uses OpenAI for intelligent processing and querying
- Generates embeddings for messages and calculates importance
- Provides summaries of recent messages
- Answers questions based on stored message history

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'argus-discord'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install argus-discord
```

## Usage

To run the bot, create a `.env` file with the following environment variables:

```plaintext
DISCORD_BOT_TOKEN=your_discord_bot_token
OPENAI_API_KEY=your_openai_api_key
```

Then, run the bot with:

```
$ argus-discord
```

The bot will listen to the specified Discord channels, save messages to OpenAI's vector store, and interact with the LLM as needed.

## Deployment

To deploy the bot, follow these steps:

1. Ensure you have Ruby 3.0.0 or higher installed on your deployment server.

2. Clone the repository:
   ```
   git clone https://github.com/chunky-metro/argus-discord.git
   cd argus-discord
   ```

3. Install dependencies:
   ```
   bundle install
   ```

4. Set up environment variables:
   - Create a `.env` file in the project root
   - Add the required environment variables as shown in the Usage section

5. Start the bot:
   ```
   bundle exec ruby -r './lib/argus/discord.rb' -e 'Argus::Discord::Bot.new.run'
   ```

6. (Optional) Use a process manager like systemd or supervisord to keep the bot running and restart it if it crashes.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/chunky-metro/argus-discord.