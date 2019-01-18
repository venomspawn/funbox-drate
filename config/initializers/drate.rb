# frozen_string_literal: true

require "#{Rails.root}/lib/drate/actions/drate"

DRate::Actions::DRate.configure do |settings|
  settings.path = ENV['DRATE_PATH'] || "#{Rails.root}/data/drate"
end
