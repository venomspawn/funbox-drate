# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'default/page#draw'

  get '/stream', to: 'default/stream#stream'
end
