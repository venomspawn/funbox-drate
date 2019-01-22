# frozen_string_literal: true

module DRate
  module Actions
    module ARate
      # Class of actions which show administrative put dollar's rate saved in
      # file by path in {DRate::Actions::ARate} module's settings
      class Show
        # Associative array with values by default
        DEFAULT = { rate: '', time: '' }.freeze

        # Returns associative array with strings of administratively put
        # dollar's rate and time till the rate is active. If an error appears,
        # returns associative array with empty values.
        # @return [Hash]
        #   resulting associative array
        def show
          path = ARate.settings.path.to_s
          rate = IO.read(path)
          time = File.mtime(path).to_s
          { rate: rate, time: time }
        rescue StandardError
          DEFAULT
        end
      end
    end
  end
end
