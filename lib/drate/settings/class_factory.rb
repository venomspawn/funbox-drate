# frozen_string_literal: true

require_relative 'mixin'

module DRate
  module Settings
    # Provides a function to create classes of settings
    module ClassFactory
      # Creates a new class of settings with provided names, and returns it
      # @param [Array<#to_s>] names
      #   array of names of the settings
      # @return [Class]
      #   class of the settings
      def self.create(*names)
        names.map! { |name| name.is_a?(Symbol) ? name : name.to_s.to_sym }
        Struct.new(*names) { include Mixin }
      end
    end
  end
end
