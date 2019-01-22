# frozen_string_literal: true

module Default
  # Class of controllers which handle requests on streams of changes of
  # dollar's rate
  class StreamController < ApplicationController
    include ActionController::Live

    # Associative array of headers
    HEADERS = { 'Content-Type' => 'text/event-stream' }.freeze

    # Handles GET-request with `/stream` path
    def stream
      setup_response_headers(HEADERS)
      register
      sleep_and_ping while registered?
    rescue StandardError
      nil
    ensure
      response.stream.close
    end

    private

    # Sets headers of the response accordingly with the provided associative
    # array
    # @param [Hash] headers
    #   associative array of headers
    def setup_response_headers(headers)
      headers.each { |header, value| response.headers[header] = value }
    end

    # Registers response stream in the pool
    def register
      DRate::Streams.instance.register(response.stream)
    end

    # Returns if response stream is registered or not
    # @return [Boolean]
    #   if response stream is registered or not
    def registered?
      DRate::Streams.instance.include?(response.stream)
    end

    # String with ping message
    PING_MESSAGE = "\n\n"

    # Sleep delay in seconds
    DELAY = 5

    # Sleep for {DELAY} seconds and pings connection
    def sleep_and_ping
      sleep(DELAY)
      response.stream.write(PING_MESSAGE)
    end
  end
end
