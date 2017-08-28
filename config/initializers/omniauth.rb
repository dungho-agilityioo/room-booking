OmniAuth.config.logger = Rails.logger
# frozen_string_literal: true

# Google's OAuth2 docs. Make sure you are familiar with all the options
# before attempting to configure this gem.
# https://developers.google.com/accounts/docs/OAuth2Login

Rails.application.config.middleware.use OmniAuth::Builder do
  # Default usage, this will give you offline access and a refresh token
  # using default scopes 'email' and 'profile'
  #
  # provider :gitlab, ENV['GITLAB_KEY'], ENV['GITLAB_SECRET'],
  #       provider_ignores_state: true,
  #       client_options: {
  #          site: ENV['SITE_URL'],
  #          provider_ignores_state: true,
  #          scope: 'read_user,api',
  #       }
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
    {
      name: "google",
      prompt: "select_account",
      image_aspect_ratio: "square",
      image_size: 50,
      access_type: 'offline',
      provider_ignores_state: true
    }
end
