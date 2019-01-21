# frozen_string_literal: true

require 'singleton'
require 'rb-inotify'

module DRate
  # Class of notifiers on closing of a file opened for writing
  class Notifier
    include Singleton

    # Initializes class instance
    def initialize
      @notifier = INotify::Notifier.new
      @watchers = {}
      @mutex = Thread::Mutex.new
      @thread = Thread.new { notifier.run }
    end

    # Adds subscription on closing of a file opened for writing. If a
    # subscription with the label is present, removes the subscription. Yields
    # label if the file is closed after it was opened for writing.
    # @param [#to_s] path
    #   path to the file
    # @param [Object] label
    #   label
    # @yieldparam [Object] label
    #   label of the subscription
    def on_close_write(path, label)
      path = path.to_s
      mutex.synchronize do
        shutdown_watcher(label)
        watchers[label] = notifier.watch(path, :close_write) { yield label }
      end
    end

    # Removes subscription by label
    # @param [Object] label
    #   label of the subscription
    def forget(label)
      mutex.synchronize { shutdown_watcher(label) }
    end

    private

    # Notifier object
    # @return [INotify::Notifier]
    #   notifier object
    attr_reader :notifier

    # Associative array with labels as its keys and event watchers as its
    # values
    # @return [Hash{Object => INotify::Watcher}]
    #   associative array of labels and watchers
    attr_reader :watchers

    # Synchronization object
    # @return [Thread::Mutex]
    #   synchronization object
    attr_reader :mutex

    # Closes watcher by provided label and removes it from {watchers}
    # associative array. Raises no exceptions on errors.
    # @param [Object] label
    #   label of subscription
    def shutdown_watcher(label)
      watchers.delete(label)&.close
    rescue StandardError
      nil
    end
  end
end
