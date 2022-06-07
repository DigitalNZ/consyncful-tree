# frozen_string_literal: true

class TestChild < Consyncful::Base
  include ConsyncfulTree::Child

  contentful_model_name "testChild"

  field :title, type: String
end

class TestParent < Consyncful::Base
  contentful_model_name "testParent"

  references_many :child_models

  field :title, type: String
end

RSpec.describe ConsyncfulTree::Child do
  describe ".parents" do
    it "returns a list of parents" do
      child = TestChild.create(title: "I'm a child")
      TestParent.create(title: "I'm a parent", child_models: [child])
      expect(child.parents.first.title).to eq "I'm a parent"
    end
  end
end
