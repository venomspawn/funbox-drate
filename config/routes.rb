# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'default/page#draw'

  get '/stream', to: 'default/stream#stream'
  get '/admin', to: 'admin/page#draw'
  post '/admin', to: 'admin/rate#save'
end
