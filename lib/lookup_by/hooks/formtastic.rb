require "active_support/concern"

module LookupBy
  module Hooks
    module Formtastic
      extend ActiveSupport::Concern

      included do
        alias_method_chain :input, :lookup
      end

      def input_with_lookup(method, options = {})
        klass = object.class

        if klass.respond_to?(:lookups) && klass.lookups.include?(method.to_sym)
          target = method.to_s.classify.constantize

          options[:collection] ||= target.pluck(target.lookup.field) if target.lookup.has_cache?
        end

        input_without_lookup(method, options)
      end
    end
  end
end

::Formtastic::FormBuilder.send :include, LookupBy::Hooks::Formtastic
