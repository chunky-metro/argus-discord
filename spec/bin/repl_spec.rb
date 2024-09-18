require 'spec_helper'

RSpec.describe 'bin/repl' do
  let(:repl_content) { File.read('bin/repl') }

  it 'is an executable file' do
    expect(File.executable?('bin/repl')).to be true
  end

  it 'contains the necessary requires' do
    expect(repl_content).to include("require 'bundler/setup'")
    expect(repl_content).to include("require 'argus/discord'")
    expect(repl_content).to include("require 'irb'")
  end

  it 'initializes and runs the bot' do
    expect(repl_content).to include('bot = Argus::Discord::Bot.new')
    expect(repl_content).to include('bot_thread = Thread.new { bot.run }')
  end

  it 'defines custom methods for bot interaction' do
    expect(repl_content).to include('def bot_context')
    expect(repl_content).to include('def bot_info')
    expect(repl_content).to include('def list_servers')
    expect(repl_content).to include('def list_channels')
  end

  it 'sets up a custom IRB workspace' do
    expect(repl_content).to include('IRB.setup nil')
    expect(repl_content).to include('workspace = IRB::WorkSpace.new(binding)')
    expect(repl_content).to include('irb = IRB::Irb.new(workspace)')
    expect(repl_content).to include('IRB.conf[:MAIN_CONTEXT] = irb.context')
  end

  it 'starts an IRB session' do
    expect(repl_content).to include('IRB.start')
  end

  it 'stops the bot when exiting' do
    expect(repl_content).to include('bot.stop')
    expect(repl_content).to include('bot_thread.join')
  end
end