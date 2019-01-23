# frozen_string_literal: true

require_relative '../base/action'

module DRate
  module Actions
    module ARate
      # Class of actions which save administratively put dollar's rate
      class Save < Base::Action
        require_relative 'save/params_schema'

        # Performs the following:
        #
        # *   saves dollar's rate to the files by paths in settings of
        #     {DRate::Actions::ARate} and {DRate::Actions::DRate} modules;
        # *   sets `mtime` time of the same files to the one specified in
        #     action parameters
        # @raise [ArgumentError]
        #   if date and time can't be recovered from action parameters
        def save
          mtime = parse_time
          save_rate(ARate.settings.path, mtime)
          save_rate(DRate.settings.path, mtime)
        end

        private

        # Returns value of `rate` parameter
        # @return [String]
        #   value of `rate` parameter
        def rate
          params[:rate]
        end

        # String with format for `Time#strptime`
        STRPTIME_FORMAT = '%Y-%m-%d %H:%M:%S'

        # Recovers and returns time from values in action parameters
        # @return [Time]
        #   recovered time
        # @raise [ArgumentError]
        #   if date and time can't be recovered from action parameters
        def parse_time
          Time.strptime("#{params[:date]} #{params[:time]}", STRPTIME_FORMAT)
        end

        # Saves dollar's rate to the file by the path and updates modification
        # time of the file
        # @param [#to_s] path
        #   file's path
        # @param [Time] mtime
        #   modification time of the file
        def save_rate(path, mtime)
          path = path.to_s
          IO.write(path, rate)
          File.utime(Time.now, mtime, path)
        end
      end
    end
  end
end
