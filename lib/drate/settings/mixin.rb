# frozen_string_literal: true

module DRate
  # Namespace of modules which provide methods to work with settings
  module Settings
    # Provides methods to set individual settings
    module Mixin
      # Sets value of a setting
      # @param [#to_s] setting
      #   name of the setting
      # @param [Object] value
      #   value of the setting
      def set(setting, value)
        send("#{setting}=", value)
      end

      # Sets value of a setting to boolean `true`
      # @param [#to_s] setting
      #   name of the setting
      def enable(setting)
        set(setting, true)
      end

      # Sets value of a setting to boolean `false`
      # @param [#to_s] setting
      #   name of the setting
      def disable(setting)
        set(setting, false)
      end
    end
  end
end
