# frozen_string_literal: true

require "active_support/concern"

module Consyncful
  module Tree
    module Child
      extend ActiveSupport::Concern

      included do
        after_save do
          parents.map(&:touch)
        end

        def parents
          Consyncful::Base.where(child_model_ids: id)
        end
      end
    end
  end
end
