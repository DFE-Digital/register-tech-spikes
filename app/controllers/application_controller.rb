class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: ENV.fetch("USERNAME", SecureRandom.uuid), password: ENV.fetch("PASSWORD", SecureRandom.uuid) unless Rails.env.development?
end
