# frozen_string_literal: true

require 'spec_helper'
require 'rake'

RSpec.describe 'discord:leave_channels' do
  before(:all) do
    Rake.application.rake_require 'tasks/leave_channels'
    Rake::Task.define_task(:environment)
  end

  let(:task) { Rake::Task['discord:leave_channels'] }
  let(:bot_instance) { instance_double(Argus::Discord::Bot) }
  let(:bot) { instance_double(Discordrb::Bot) }
  let(:logger) { instance_double(Argus::Discord::Logger) }

  before do
    allow(Argus::Discord::Bot).to receive(:new).and_return(bot_instance)
    allow(bot_instance).to receive(:bot).and_return(bot)
    allow(Argus::Discord::Logger).to receive(:new).and_return(logger)
    allow(logger).to receive(:info)
    allow(logger).to receive(:warn)
    allow(logger).to receive(:error)
  end

  it 'leaves channels not in incoming-data-* categories' do
    server = instance_double(Discordrb::Server)
    channel1 = instance_double(Discordrb::Channel, name: 'channel1', category: nil)
    channel2 = instance_double(Discordrb::Channel, name: 'channel2', category: instance_double(Discordrb::Channel, name: 'regular-category'))
    channel3 = instance_double(Discordrb::Channel, name: 'channel3', category: instance_double(Discordrb::Channel, name: 'incoming-data-crypto'))

    allow(bot).to receive(:servers).and_return({ '1' => server })
    allow(server).to receive(:channels).and_return([channel1, channel2, channel3])

    [channel1, channel2].each do |channel|
      expect(channel).to receive(:last_message_id).and_return(nil)
      expect(channel).to receive(:leave)
    end

    expect(channel3).not_to receive(:leave)

    task.invoke
  end

  it 'handles errors gracefully' do
    server = instance_double(Discordrb::Server)
    channel = instance_double(Discordrb::Channel, name: 'error_channel', category: nil)

    allow(bot).to receive(:servers).and_return({ '1' => server })
    allow(server).to receive(:channels).and_return([channel])
    allow(channel).to receive(:last_message_id).and_raise(StandardError, 'Test error')

    expect(logger).to receive(:error).with(/Error leaving channel: #error_channel/)

    task.invoke
  end
end