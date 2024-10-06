# frozen_string_literal: true

require_relative "lib/argus/discord/version"

Gem::Specification.new do |spec|
  spec.name = "argus-discord"
  spec.version = Argus::Discord::VERSION
  spec.authors = ["rhiza"]
  spec.email = ["rhiza@shitposti.ng"]

  spec.summary = "A Discord bot for monitoring announcements and interacting with an LLM using RAG."
  spec.description = "This bot listens to Discord channels, saves messages to OpenAI's vector store, and uses OpenAI for intelligent processing and querying."
  spec.homepage = "https://github.com/chunky-metro/argus-discord"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/chunky-metro/argus-discord"
  spec.metadata["changelog_uri"] = "https://github.com/chunky-metro/argus-discord/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .github])
    end
  end
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "discordrb", "~> 3.5"
  spec.add_dependency "dotenv", "~> 3.1"
  spec.add_dependency "ruby-openai", "~> 7.1"

  spec.add_development_dependency "rake", "~> 13.2"
  spec.add_development_dependency "rspec", "~> 3.13"
  spec.add_development_dependency "standard", "~> 1.40"
end