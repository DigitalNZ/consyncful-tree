# frozen_string_literal: true

class TestChild < Consyncful::Base
  include Consyncful::Tree::Child
  include Consyncful::Tree::Parent

  contentful_model_name "testChild"

  references_many :test_grandchildren

  field :title, type: String
end
