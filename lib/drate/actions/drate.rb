# frozen_string_literal: true

require_relative '../settings/configurable'

module DRate
  module Actions
    # Module of actions on dollar's rates
    # @!method self.settings
    #   Returns object which allows to set and access path to file with
    #   dollar's rate
    #   @return [#path, #path=]
    #     settings object
    # @!method self.configure
    #   Yields object which allows to set and access path to file with dollar's
    #   rate
    #   @yield [#path, @path=]
    #     settings object
    module DRate
      extend Settings::Configurable

      settings_names :path

      require_relative 'drate/fetch'

      # Fetches dollar's rate from external site and returns a string with it
      # @return [String]
      #   string with dollar's rate
      def self.fetch
        Fetch.new.fetch
      end

      require_relative 'drate/show'

      # Returns string with dollar's rate saved by path in settings. If an
      # error appears, returns empty string.
      # @return [String]
      #   resulting string
      def self.show
        Show.new.show
      end
    end
  end
end
