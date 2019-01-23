# frozen_string_literal: true

module DRate
  module Actions
    module ARate
      class Show
        # JSON-schema of action result
        RESULT_SCHEMA = {
          oneOf: [
            {
              type: :object,
              properties: {
                rate: {
                  type: :string
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
            },
            {
              type: :object,
              properties: {
                rate: {
                  type: :string,
                  enum: ['']
                },
                date: {
                  type: :string,
                  enum: ['']
                },
                time: {
                  type: :string,
                  enum: ['']
                }
              },
              required: %i[
                rate
                date
                time
              ],
              additionalProperties: false
            }
          ]
        }.freeze
      end
    end
  end
end
