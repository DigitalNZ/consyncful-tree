# frozen_string_literal: true

require "active_support/concern"

# Parent module is included to parent Consyncful models
# This module allows the current parent class to lookup its children no matter where they are.
module Consyncful
  module Tree
    module Parent
      extend ActiveSupport::Concern

      # We can determine these classes automatically,
      # but you will have hard time finding them since we have lots of models.
      ROOT_CLASSES = [
        "Consyncful::Page",
        "Consyncful::Event",
        "Consyncful::EventSeries",
        "Consyncful::BlogPage",
        "Consyncful::HomePage"
      ].freeze

      included do
        references_many :child_models

        before_save do
          self.child_model_ids = lookup_child_model_ids
        end
      end

      def lookup_child_model_ids(context: self)
        context.relations.map do |key, val|
          child_ids = context[val.foreign_key]
          child_ids = Array.wrap(child_ids)

          next if key == "child_models" || child_ids.empty?

          child_ids + lookup_child_objects(child_ids)
        end.flatten.compact
      end

      def lookup_child_objects(child_ids)
        return [] if child_ids.empty?

        child_ids.map do |id|
          obj = Consyncful::Base.where(id: id).first

          next if obj.nil?

          lookup_child_model_ids(context: obj) if ROOT_CLASSES.exclude?(obj.class.to_s)
        end.flatten.compact
      end

      # Returns true/false if the parent has a child model with a specific class.
      # This is useful if you want to trace a child's class on a specific parent.
      def with_child_class_of?(klass)
        return false if klass.nil?

        klasses = child_models.map(&:class).uniq.map(&:to_s)

        klasses.include?(klass.to_s)
      end
    end
  end
end
