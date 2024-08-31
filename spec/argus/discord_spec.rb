# frozen_string_literal: true

require "spec_helper"

RSpec.describe Argus::Discord do
  it "has a version number" do
    expect(Argus::Discord::VERSION).not_to be nil
  end

  it "provides access to the Bot class" do
    expect(Argus::Discord::Bot).to be_a(Class)
  end

  it "provides access to the Database class" do
    expect(Argus::Discord::Database).to be_a(Class)
  end

  it "provides access to the LLM class" do
    expect(Argus::Discord::LLM).to be_a(Class)
  end

  it "provides access to the Assistant class" do
    expect(Argus::Discord::Assistant).to be_a(Class)
  end
end
