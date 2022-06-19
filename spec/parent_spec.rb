# frozen_string_literal: true

require_relative "test_models/test_grandchild"
require_relative "test_models/test_child"
require_relative "test_models/test_parent"
require_relative "test_models/test_grandchild_that_knows_a_parent"

RSpec.describe Consyncful::Tree::Parent do
  # Build a page data with nested child
  let(:grandchild) { TestGrandchild.create(title: "I'm a grandchild") }
  let(:child) { TestChild.create(title: "I'm a child", test_grandchildren: [grandchild]) }
  let!(:parent) { TestParent.create(title: "I'm a parent", test_children: [child]) }

  describe "#lookup_child_model_ids" do
    it "contains the id of direct children" do
      expect(parent.child_model_ids).to include child.id
    end

    it "contains the id of indirect children" do
      expect(parent.child_model_ids).to include grandchild.id
    end

    # I think the idea here is that something that is a parent with it's dependencies is a
    # unit that will be displayed together. So if there is a dependency that is a parent, we
    # probably aren't going to be displaying it
    context "when the model has a dependency that is a parent" do
      let(:other_parents_child) { TestChild.create(title: "I'm a child we don't care about!") }
      let(:another_parent) { TestParent.create(title: "I'm another parent") }

      let(:grandchild) { TestGrandchildThatKnowsAParent.create(title: "I'm a grandchild", parent: another_parent) }
      let(:child) { TestChild.create(title: "I'm a child", test_grandchildren: [grandchild]) }
      let!(:parent) { TestParent.create(title: "I'm a parent", test_children: [child]) }

      it "includes all it's dependencies" do
        expect(parent.child_model_ids).to include child.id
      end

      it "contains the id of indirect children" do
        expect(parent.child_model_ids).to include grandchild.id
      end

      # NOTE: we probably don't care about this one either, but it currently includes it.
      it "includes the parent dependency" do
        expect(parent.child_model_ids).to include another_parent.id
      end

      it "doesn't include the children of the parent dependency" do
        expect(parent.child_model_ids).not_to include other_parents_child.id
      end
    end

    context "when the parent has a cyclic dependency to itself" do
      let(:grandchild) { TestGrandchildThatKnowsAParent.create(title: "I'm a grandchild") }
      let(:child) { TestChild.create(title: "I'm a child", test_grandchildren: [grandchild]) }
      let!(:parent) { TestParent.create(title: "I'm a parent", test_children: [child]) }

      before do
        grandchild.parent = parent
        grandchild.save
      end

      it "doesn't get stuck in a loop" do
        parent.child_model_ids
        expect(1).to eq 1
      end
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
