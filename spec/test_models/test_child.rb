# frozen_string_literal: true

class TestChild < Consyncful::Base
  include Mongoid::Timestamps
  include Consyncful::Tree::Child

  contentful_model_name "testChild"

  references_many :test_grandchildren

  field :title, type: String
end
