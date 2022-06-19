# frozen_string_literal: true

require "active_support/concern"

# Parent module is included to parent Consyncful models
# This module allows the current parent class to lookup its children no matter where they are.
module Consyncful
  module Tree
    module Parent
      extend ActiveSupport::Concern

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

          child_objects = Consyncful::Base.where(id: { "$in": child_ids })

          child_ids + lookup_child_model_ids_for_list(child_objects)
        end.flatten
      end

      def lookup_child_model_ids_for_list(child_objects)
        return [] if child_objects.empty?

        child_objects.map do |obj|
          obj_is_parent = classes_with_parent_concern.include?(obj.class)
          lookup_child_model_ids(context: obj) unless obj_is_parent
        end.flatten
      end

      # Returns true/false if the parent has a child model with a specific class.
      # This is useful if you want to trace a child's class on a specific parent.
      def with_child_class_of?(klass)
        return false if klass.nil?

        klasses = child_models.map(&:class).uniq.map(&:to_s)

        klasses.include?(klass.to_s)
      end

      private

      # NOTE: I think this break condition is a bit odd.
      # It works if we think about a "Parent" being a unit that's fields and dependencies will display on
      # one page; if it isn't content we are going to display with the parent, then we don't care.
      # It protects us from some kinds of cyclic depencencies.
      #
      # However, if we changed our recursive method to instead pass down the children that had been found so far and
      # only check its children's children if they aren't in the list yet, then we'd be protected from all
      # cyclic dependencies.
      # I ran out of time to make that change.

      def classes_with_parent_concern
        # ObjectSpace lets you interact with garbage collection and traverse alive objects.
        # This will iterate through all the classes for objects that are alive.
        #
        # NOTE: when a Rails app is running, it will have all the classes loaded, but in tests or the console
        # for this Gem, it will just be the ones used in the test.
        ObjectSpace.each_object(Class).select { |c| c.included_modules.include?(Consyncful::Tree::Parent) }
      end
    end
  end
end
