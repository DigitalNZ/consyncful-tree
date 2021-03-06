# frozen_string_literal: true

class TestGrandchild < Consyncful::Base
  include Mongoid::Timestamps
  include Consyncful::Tree::Child

  contentful_model_name "testGrandchild"

  field :title, type: String
end
