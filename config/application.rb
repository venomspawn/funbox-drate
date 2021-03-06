# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'action_controller/railtie'
require 'action_view/railtie'

Bundler.require(*Rails.groups)

Dotenv::Railtie.load

module DRate
  class Application < Rails::Application
    config.load_defaults 5.2

    config.generators.system_tests = nil
  end
end
