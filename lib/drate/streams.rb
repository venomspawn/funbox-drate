# frozen_string_literal: true

module DRate
  # Class of pools which manage stream-like objects
  class Streams
    include Singleton

    # Initializes instance
    def initialize
      @streams = []
      @mutex = Thread::Mutex.new
    end

    # Returns if the stream is in the pool or not
    # @param [Object] stream
    #   stream
    # @return [Boolean]
    #   if the object is in the pool or not
    def include?(stream)
      streams.include?(stream)
    end

    # Adds stream to the pool, if the stream is not in the pool yet
    # @param [#write] stream
    #   stream-like object
    def register(stream)
      mutex.synchronize { streams.push(stream) unless include?(stream) }
    end

    # Broadcasts data to the streams. If a stream raises an exception, removes
    # the stream from the pool.
    # @param [String] data
    #   data
    def broadcast(data)
      message = create_message(data)
      streams.dup.each do |stream|
        stream.write(message)
      rescue StandardError
        mutex.synchronize { streams.delete(stream) }
      end
    end

    # Clears the pool
    def reset
      mutex.synchronize { streams.clear }
    end

    private

    # Synchronization object
    # @return [Thread::Mutex]
    #   synchronization object
    attr_reader :mutex

    # Array of streams
    # @return [Array]
    #   array of streams
    attr_reader :streams

    # String of line feed symbol
    LF = "\n"

    # String with line feed and start of data message in event stream format
    LF_DATA = "\ndata: "

    # Template of message string
    MESSAGE_TEMPLATE = "data: %s\n\n"

    # Creates message string with data in event stream format and returns the
    # string
    # @return [String]
    #   message with data in event stream format
    def create_message(data)
      data = data.gsub(LF, LF_DATA)
      format(MESSAGE_TEMPLATE, data)
    end
  end
end
