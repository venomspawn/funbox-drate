# frozen_string_literal: true

require "#{Rails.root}/lib/drate/actions/arate/show/result_schema"

module DRate
  module Actions
    module ARate
      class Show
        # Provides auxiliary methods to tests of containing class
        module SpecHelper
          # Returns JSON-schema of business logic result
          def schema
            RESULT_SCHEMA
          end
        end
      end
    end
  end
end
