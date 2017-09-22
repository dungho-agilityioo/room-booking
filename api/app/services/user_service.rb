class UserService

  class << self
    def create_user(params)
      user = User.find_or_initialize_by(
          provider: params[:provider],
          email: params[:info][:email] ) do |u|
        u[:name] = params[:info][:name]
        u[:first_name] = params[:info][:first_name]
        u[:last_name] = params[:info][:last_name]
        u[:uid] = params[:uid]
      end
      user.skip_password_validation = true

      unless user.save
        user.uid = params[:uid]
        user.save
      end

      user
    end

    def create_admin
      User.find_or_create_by!(email: ENV['ADMIN_EMAIL']) do |u|
        u.provider = 'gitlab'
        u.uid = Time.now.to_i
        u.name = ENV['ADMIN_NAME']
        u.skip_password_validation = true
        u.admin!
      end
    end
  end
end
