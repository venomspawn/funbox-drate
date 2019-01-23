# frozen_string_literal: true

module Admin
  # Class of controllers which handle requests on saving of administratively
  # put dollar's rate
  class RateController < ApplicationController
    # Handles POST-request with `/admin` path
    def save
      notice = save_rate
      redirect_to admin_url, notice: notice
    end

    private

    # Returns associative array with indifferent access to parameter values of
    # action of saving dollar's rate
    # @return [HashWithIndifferentAccess]
    #   resulting associtative array
    def action_params
      hash = { rate: params[:rate], date: params[:date], time: params[:time] }
      hash.with_indifferent_access
    end

    # Notice on invalid request parameters
    NOTICE_INVALID_PARAMS = 'Invalid structure or value of request parameters'

    # Notice on invalid values of date or time in request parameters
    NOTICE_INVALID_DATETIME =
      'Invalid values of date or time in request parameters'

    # Notice on general error
    NOTICE_ERROR = 'General processing error'

    # Invokes action of saving dollar's rate. Returns `nil` on success or a
    # string with error message otherwise.
    # @return [NilClass]
    #   if the dollar's rate has been successfully saved
    # @return [String]
    #   if an error appears
    def save_rate
      DRate::Actions::ARate.save(action_params)
      nil
    rescue JSON::Schema::ValidationError
      NOTICE_INVALID_PARAMS
    rescue ArgumentError
      NOTICE_INVALID_DATETIME
    rescue StandardError
      NOTICE_ERROR
    end
  end
end
