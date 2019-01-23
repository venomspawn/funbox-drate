# frozen_string_literal: true

module DRate
  module Actions
    module ARate
      # Class of actions which show administrative put dollar's rate saved in
      # file by path in {DRate::Actions::ARate} module's settings
      class Show
        # Associative array with values by default
        DEFAULT = { rate: '', date: '', time: '' }.freeze

        # String with date format
        DATE_FORMAT = '%Y-%m-%d'

        # String with time format
        TIME_FORMAT = '%H:%M:%S'

        # Returns associative array with strings of administratively put
        # dollar's rate and time till the rate is active. If an error appears,
        # returns associative array with empty values.
        # @return [Hash]
        #   resulting associative array
        def show
          path = ARate.settings.path.to_s
          rate = IO.read(path)
          mtime = File.mtime(path)
          date = mtime.strftime(DATE_FORMAT)
          time = mtime.strftime(TIME_FORMAT)
          { rate: rate, date: date, time: time }
        rescue StandardError
          DEFAULT
        end
      end
    end
  end
end
