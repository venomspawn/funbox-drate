# frozen_string_literal: true

require "#{Rails.root}/lib/drate/actions/arate"

arate_path = "#{Rails.root}/data/arate"

DRate::Actions::ARate.configure do |settings|
  settings.path = arate_path
end
