# frozen_string_literal: true

require 'http'

module DRate
  module Actions
    module DRate
      # Class of actions that fetch dollar's rate from external sites
      class Fetch
        # URL of site to fetch data from
        URL = 'http://www.cbr.ru/scripts/XML_daily.asp'

        # Regular expression to extract dollar's rate
        REGEXP =
          %r{<Valute ID="R01235">.*<Value>(.*)</Value>.*</Valute>}.freeze

        # Default value in case of errors
        DEFAULT = ''

        # Fetches dollar's rate from external site and returns a string with it
        # @return [String]
        #   string with dollar's rate
        def fetch
          content = HTTP.get(URL)
          REGEXP.match(content)[1]
        rescue StandardError
          DEFAULT
        end
      end
    end
  end
end
