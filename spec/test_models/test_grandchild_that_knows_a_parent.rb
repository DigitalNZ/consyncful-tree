# frozen_string_literal: true

class TestGrandchildThatKnowsAParent < Consyncful::Base
  include Mongoid::Timestamps
  include Consyncful::Tree::Child

  contentful_model_name "testChild"

  references_one :parent

  field :title, type: String
end
