# frozen_string_literal: true

require "argus/discord"
require "dotenv/load"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Mock environment variables
  config.before(:each) do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("DISCORD_BOT_TOKEN").and_return("mock_discord_token")
    allow(ENV).to receive(:[]).with("OPENAI_API_KEY").and_return("mock_openai_key")
  end
end