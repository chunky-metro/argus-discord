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

### Interactive REPL

To interact with the bot in a REPL environment, you can use the `bin/repl` script:

```
$ ./bin/repl
```

This will start the bot in a separate thread and drop you into an IRB session where you can interact with the bot using the `bot` variable. The REPL provides several custom commands to help you interact with the bot:

- `bot_info`: Display basic information about the bot, including its username, user ID, and the number of servers and channels it's connected to.
- `list_servers`: Show a list of all servers the bot is connected to.
- `list_channels`: Display all channels the bot is monitoring across all servers.
- `bot_context`: Get a hash containing the bot's current context, including its username, user ID, servers, and channels.

You can also interact directly with the bot object. For example:

```ruby
# Send a message to a specific channel
channel_id = '123456789'
bot.send_message(channel_id, 'Hello from the REPL!')

# Get information about a specific server
server = bot.servers.first
puts "Server name: #{server.name}, Member count: #{server.member_count}"

# Perform any other operations available on the bot object
```

To stop the bot and exit the REPL, use the command:

```ruby
bot.stop
exit
```

Remember to set up your environment variables in the `.env` file before using the REPL.

### Rake Tasks

#### Leave Channels

To leave all channels except those in categories starting with `incoming-data-`, use the following rake task:

```
$ rake discord:leave_channels
```

This task will:
- Connect to Discord using the bot token
- Iterate through all servers and channels the bot is in
- Leave channels that are not in categories starting with `incoming-data-`
- Log the actions taken and any errors encountered

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