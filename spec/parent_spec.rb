# frozen_string_literal: true

require_relative "test_models/test_grandchild"
require_relative "test_models/test_child"
require_relative "test_models/test_parent"

RSpec.describe Consyncful::Tree::Parent do
  # Build a page data with nested child
  let!(:grandchild) { TestGrandchild.create(title: "I'm a grandchild") }
  let!(:child) { TestChild.create(title: "I'm a child", test_grandchildren: [grandchild]) }
  let!(:parent) { TestParent.create(title: "I'm a parent", test_children: [child]) }

  describe "#lookup_child_model_ids" do
    it "contains the id of direct children" do
      expect(parent.child_model_ids).to include child.id
    end

    it "contains the id of indirect children" do
      expect(parent.child_model_ids).to include grandchild.id
    end
  end

  describe "#with_child_class_of?" do
    it "returns true" do
      expect(parent.with_child_class_of?(TestChild)).to eq true
    end

    it "returns false" do
      expect(parent.with_child_class_of?(Array)).to eq false
    end
  end
end
