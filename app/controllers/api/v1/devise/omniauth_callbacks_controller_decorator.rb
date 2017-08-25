class Api::V1::Devise::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # Sets flash message if is_flashing_format? equals true
  def set_flash_message!(key, kind, options = {})
    if is_flashing_format?
      set_flash_message(key, kind, options)
    end
  end
end
