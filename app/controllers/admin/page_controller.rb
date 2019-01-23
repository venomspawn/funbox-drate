# frozen_string_literal: true

# Namespace for classes of controllers which handle requests on administrative
# measures
module Admin
  # Class of controllers which handle requests on page with administratively
  # put dollar's rate
  class PageController < ApplicationController
    # Handles GET-request with `/admin` path
    def draw
      arate = DRate::Actions::ARate.show
      render :page, locals: { arate: arate }
    end
  end
end
