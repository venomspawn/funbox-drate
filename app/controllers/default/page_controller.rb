# frozen_string_literal: true

# Namespace for classes of controllers which handle requests on showing
# dollar's rate
module Default
  # Class of controllers which handle requests on page with dollar's rate
  class PageController < ApplicationController
    # Handles GET-request with `/` path
    def draw
      drate = DRate::Actions::DRate.show
      render :page, locals: { drate: drate }
    end
  end
end
