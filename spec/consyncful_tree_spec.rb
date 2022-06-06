# frozen_string_literal: true

RSpec.describe ConsyncfulTree do
  it "has a version number" do
    expect(ConsyncfulTree::VERSION).not_to be nil
  end

  it "has the child concern" do
    expect(ConsyncfulTree::Child).not_to be nil
  end
end
