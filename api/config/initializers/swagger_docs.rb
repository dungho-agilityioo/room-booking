if Rails.env.development?
  Swagger::Docs::Config.register_apis({
    "1.0" => {
      # the output location where your .json files are written to
      :api_file_path => "public/docs/",
      # :controller_base_path => "api/v1",
      # the URL base path to your API
      :base_path => '/',
      # if you want to delete all .json files at each generation
      :clean_directory => false,
      # Ability to setup base controller for each api version. Api::V1::SomeController for example.
      # :parent_controller => ApplicationController,
      # add custom attributes to api-docs
      :attributes => {
        :info => {
          "title" => "Room Booking Api App",
          "description" => "Agility IO micro app: Rooms Booking.",
          "contact" => "dung.hoduy@asnet.com.vn",
        }
      }
    }
  })

  class Swagger::Docs::Config
    def self.transform_path(path, api_version)
      # Make a distinction between the APIs and API documentation paths.
      "docs/#{path}"
    end
  end
end
