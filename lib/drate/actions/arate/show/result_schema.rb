# frozen_string_literal: true

module DRate
  module Actions
    module ARate
      class Show
        # JSON-schema of action result
        RESULT_SCHEMA = {
          type: :object,
          properties: {
            rate: {
              type: :string
            },
            time: {
              type: :string
            }
          },
          required: %i[
            rate
            time
          ],
          additionalProperties: false
        }.freeze
      end
    end
  end
end
