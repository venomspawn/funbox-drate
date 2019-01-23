# frozen_string_literal: true

module DRate
  module Actions
    module ARate
      class Save
        # JSON-schema of action parameters
        PARAMS_SCHEMA = {
          type: :object,
          properties: {
            rate: {
              type: :string,
              pattern: /\A[0-9]+,[0-9]+\z/
            },
            date: {
              type: :string,
              pattern: /\A[0-9]{4}-[0-9]{2}-[0-9]{2}\z/
            },
            time: {
              type: :string,
              pattern: /\A[0-9]{2}:[0-9]{2}:[0-9]{2}\z/
            }
          },
          required: %i[
            rate
            date
            time
          ],
          additionalProperties: false
        }.freeze
      end
    end
  end
end
