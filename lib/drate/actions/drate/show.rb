# frozen_string_literal: true

module DRate
  module Actions
    module DRate
      # Class of actions which show dollar's rate saved by path in
      # {DRate::Actions::DRate} module's settings
      class Show
        # Empty string
        EMPTY = ''

        # Returns string with dollar's rate. If an error appears, returns empty
        # string.
        # @return [String]
        #   resulting string
        def show
          IO.read(DRate.settings.path.to_s)
        rescue StandardError
          EMPTY
        end
      end
    end
  end
end
