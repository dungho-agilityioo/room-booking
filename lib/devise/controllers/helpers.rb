def is_flashing_format?
  is_navigational_format?
end

def is_navigational_format?
  Devise.navigational_formats.include?(request_format)
end
