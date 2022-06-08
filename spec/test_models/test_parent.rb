# frozen_string_literal: true

class TestParent < Consyncful::Base
  include Mongoid::Timestamps
  include Consyncful::Tree::Parent

  contentful_model_name "testParent"

  references_many :test_children

  field :title, type: String
end
