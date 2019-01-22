# frozen_string_literal: true

require "#{Rails.root}/lib/drate/actions/drate"
require "#{Rails.root}/lib/drate/notifier"
require "#{Rails.root}/lib/drate/streams"

drate_path = "#{Rails.root}/data/drate"

DRate::Actions::DRate.configure do |settings|
  settings.path = drate_path
end
