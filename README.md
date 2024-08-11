# Argus::Discord

A Discord bot for monitoring announcements and interacting with an LLM using Retrieval Augmented Generation (RAG).

## Features

- Listens to Discord channels and saves messages to Weaviate vector database
- Uses OpenAI and Langchain for intelligent processing and querying
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
WEAVIATE_URL=your_weaviate_url
WEAVIATE_API_KEY=your_weaviate_api_key
```

Then, run the bot with:

```
$ argus-discord
```

The bot will listen to the specified Discord channels, save messages to Weaviate, and interact with the LLM as needed.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/argus-discord.