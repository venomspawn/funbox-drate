# frozen_string_literal: true

module DRate
  # Namespace of action modules
  module Actions
    # Namespace for base action classes
    module Base
      # Base action class, which provides check if parameters correspond to
      # JSON-schema
      class Logic
        extend Validator

        # Initializes instance
        # @param [HashWithIndifferentAccess] params
        #   associative array of parameters
        # @raise [JSON::Schema::ValidationError]
        #   if associative array of parameters doesn't correspond to
        #   JSON-schema
        def initialize(params)
          self.class.validate!(params)
          @params = params
        end

        private

        # Associative array of action parameters
        # @return [HashWithIndifferentAccess]
        #   associative array of action parameters
        attr_reader :params
      end
    end
  end
end
