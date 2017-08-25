OmniAuth.config.logger = Rails.logger
# frozen_string_literal: true

# Google's OAuth2 docs. Make sure you are familiar with all the options
# before attempting to configure this gem.
# https://developers.google.com/accounts/docs/OAuth2Login

Rails.application.config.middleware.use OmniAuth::Builder do
  # Default usage, this will give you offline access and a refresh token
  # using default scopes 'email' and 'profile'
  #
  provider :gitlab, ENV['GITLAB_KEY'], ENV['GITLAB_SECRET'],
        client_options: {
           site: ENV['SITE_URL'],
        }
  # provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], scope: "user:email,user:follow"
  # Manual setup for offline access with a refresh token.
  #
  # provider :gitlab, ENV['GITLAB_KEY'], ENV['GITLAB_SECRET'], access_type: 'offline'

  # Custom scope supporting youtube. If you are customizing scopes, remember
  # to include the default scopes 'email' and 'profile'
  #
  # provider :gitlab, ENV['GITLAB_KEY'], ENV['GITLAB_SECRET'], scope: 'http://gdata.youtube.com,email,profile,plus.me'

  # Custom scope for users only using Google for account creation/auth and do not require a refresh token.
  #
  # provider :gitlab, ENV['GITLAB_KEY'], ENV['GITLAB_SECRET'], access_type: 'online', prompt: ''

  # To include information about people in your circles you must include the 'plus.login' scope.
  #
  # provider :gitlab, ENV['GITLAB_KEY'], ENV['GITLAB_SECRET'], skip_friends: false, scope: 'email,profile,plus.login'

  # If you need to acquire whether user picture is a default one or uploaded by user.
  #
  # provider :gitlab, ENV['GITLAB_KEY'], ENV['GITLAB_SECRET'], skip_image_info: false
end
