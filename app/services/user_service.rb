class UserService

  class << self
    def create_user(params)
      user = User.find_or_initialize_by(
          provider: params[:provider],
          uid: params[:uid],
          email: params[:info][:email] ) do |u|
        u[:name] = params[:info][:name]
        u[:first_name] = params[:info][:first_name]
        u[:last_name] = params[:info][:last_name]
      end
      user.skip_password_validation = true

      return user if user.save
      errors.add_multiple_errors user.errors.messages
    end

    def create_admin
      User.find_or_create_by!(email: ENV['ADMIN_EMAIL']) do |u|
        u.provider = 'gitlab'
        u.uid = Faker::Number.number(10)
        u.name = ENV['ADMIN_NAME']
        u.skip_password_validation = true
        u.admin!
      end
    end
  end
end
