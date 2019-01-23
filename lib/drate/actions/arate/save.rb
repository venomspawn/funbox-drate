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
          mtime = parsed_time
          IO.write(ARate.settings.path, rate)
          File.utime(Time.now, mtime, ARate.settings.path)
          IO.write(DRate.settings.path, rate)
          File.utime(Time.now, mtime, DRate.settings.path)
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
        def parsed_time
          Time.strptime("#{params[:date]} #{params[:time]}", STRPTIME_FORMAT)
        end
      end
    end
  end
end
