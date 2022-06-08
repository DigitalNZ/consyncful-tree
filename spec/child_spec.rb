# frozen_string_literal: true

require_relative "test_models/test_child"
require_relative "test_models/test_parent"

RSpec.describe Consyncful::Tree::Child do
  let!(:child) { TestChild.create(title: "I'm a child") }
  let!(:parent) { TestParent.create(title: "I'm a parent", test_children: [child]) }

  describe ".parents" do
    it "returns a list of parents" do
      expect(child.parents.first.title).to eq "I'm a parent"
    end
  end

  # context "after the child model is saved" do
  #   it "touches the parents" do
  #     expect(parent).to receive(:touch)
  #     child.save
  #   end
  # end
end
