# frozen_string_literal: true

desc 'Repeatingly fetches dollar\'r rate and saves it to a file'
task run_fetcher: :environment do
  default = 30
  delay = begin
            Integer(ENV['DRATE_REFRESH_DELAY'])
          rescue StandardError
            default
          end
  delay = default unless delay.positive?

  path = DRate::Actions::DRate.settings.path

  Thread.new do
    loop do
      next sleep(delay) if File.mtime(path) > Time.now

      IO.write(path, DRate::Actions::DRate.fetch)
      sleep(delay)
    end
  end

  %w[INT TERM].each { |signal| Signal.trap(signal) { Thread.exit } }

  sleep
end
