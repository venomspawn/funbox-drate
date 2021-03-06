# frozen_string_literal: true

Rails.application.configure do
  config.action_controller.allow_forgery_protection = false
  config.action_controller.perform_caching          = false

  config.action_dispatch.show_exceptions = false

  config.active_support.deprecation = :stderr

  config.cache_classes = true

  config.consider_all_requests_local = true

  config.eager_load = true

  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.to_i}"
  }
end
