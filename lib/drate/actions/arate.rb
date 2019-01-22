# frozen_string_literal: true

require_relative '../settings/configurable'

module DRate
  module Actions
    # Module of actions on administratively put dollar's rates
    # @!method self.settings
    #   Returns object which allows to set and access path to file with
    #   administratively put dollar's rate
    #   @return [#path, #path=]
    #     settings object
    # @!method self.configure
    #   Yields object which allows to set and access path to file with
    #   administratively put dollar's rate
    #   @yield [#path, @path=]
    #     settings object
    module ARate
      extend Settings::Configurable

      settings_names :path

      require_relative 'arate/show'

      # Returns associative array with strings of administratively put dollar's
      # rate and time till the rate is active. If an error appears, returns
      # associative array with empty values.
      # @return [Hash]
      #   resulting associative array
      def self.show
        Show.new.show
      end
    end
  end
end
