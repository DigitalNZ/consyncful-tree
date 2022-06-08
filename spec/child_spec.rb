# frozen_string_literal: true

class TestChild < Consyncful::Base
  include Consyncful::Tree::Child

  contentful_model_name "testChild"

  field :title, type: String
end

class TestParent < Consyncful::Base
  contentful_model_name "testParent"

  references_many :child_models

  field :title, type: String
end

RSpec.describe Consyncful::Tree::Child do
  let!(:child) { TestChild.create(title: "I'm a child") }
  let!(:parent) { TestParent.create(title: "I'm a parent", child_models: [child]) }

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
