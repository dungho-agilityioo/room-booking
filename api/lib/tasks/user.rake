namespace :user do
  desc 'Create admin user'
  task :create_admin => :environment do
    UserService.create_admin
  end
end
