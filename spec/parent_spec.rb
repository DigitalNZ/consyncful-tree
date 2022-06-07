# # frozen_string_literal: true

# class TestGrandchild < Consyncful::Base
#   include ConsyncfulTree::Child

#   contentful_model_name "testGrandchild"

#   field :title, type: String
# end

# class TestChild < Consyncful::Base
#   include ConsyncfulTree::Child
#   include ConsyncfulTree::Parent

#   contentful_model_name "testChild"

#   references_one test_grandchild

#   field :title, type: String
# end

# class TestParent < Consyncful::Base
#   include ConsyncfulTree::Parent

#   contentful_model_name "testParent"

#   references_one test_child

#   field :title, type: String
# end

# describe Consyncful::Parent do
#   # Build a page data with nested child
#   let!(:grandchild) { TestGrandchild.create(title: "I'm a grandchild") }
#   let!(:child) { TestChild.create(title: "I'm a child", test_grandchilds: [grandchild]) }
#   let!(:parent) { TestParent.create(title: "I'm a parent", test_child: child) }

#   describe "#lookup_child_model_ids" do
#     it "sets child models" do
#       expect(parent.child_model_ids).to include child.id
#       expect(parent.child_model_ids).to include grandchild.id
#     end
#   end

#   describe "#with_child_class_of?" do
#     it "returns true" do
#       expect(parent.with_child_class_of?(TestChild)).to eq true
#     end

#     it "returns false" do
#       expect(parent.with_child_class_of?(Array)).to eq false
#     end
#   end
# end
