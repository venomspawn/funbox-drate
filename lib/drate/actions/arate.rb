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

      require_relative 'arate/save'

      # Performs the following:
      #
      # *   saves dollar's rate to the files by paths in settings of
      #     {DRate::Actions::ARate} and {DRate::Actions::DRate} modules;
      # *   sets `mtime` time of the same files to the one specified in action
      #     parameters
      # @param [HashWithIndiffentAccess] params
      #   associative array of parameters of the action
      # @raise [JSON::Schema::ValidationError]
      #   if provided parameters don't satisfy JSON schema of the action's
      #   parameters
      # @raise [ArgumentError]
      #   if date and time can't be recovered from action parameters
      def self.save(params)
        Save.new(params).save
      end
    end
  end
end
