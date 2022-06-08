# frozen_string_literal: true

RSpec.describe Consyncful::Tree do
  it "has a version number" do
    expect(Consyncful::Tree::VERSION).not_to be nil
  end

  it "has the child concern" do
    expect(Consyncful::Tree::Child).not_to be nil
  end
end
