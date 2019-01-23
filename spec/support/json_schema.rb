# frozen_string_literal: true

require 'json-schema'

RSpec::Matchers.define :match_json_schema do |schema|
  match { |object| JSON::Validator.validate(schema, object) }

  failure_message do |object|
    str = JSON::Validator.fully_validate(schema, object).join('; ')
    "expected that #{object} would not bring following errors: #{str}"
  end

  description { "match JSON schema #{schema}" }
end
