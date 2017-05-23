require "rails_admin_s3_file/engine"

module RailsAdminS3File
end

require 'rails_admin/config/fields'
require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class S3File < RailsAdmin::Config::Fields::Base
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option(:partial) do
    	      :form_s3_file
    	    end

          def presigned_post
            S3_BUCKET.presigned_post(
              key: "#{ENV['AWS_ENV']}/videos/#{SecureRandom.uuid}.mp4",
              acl: 'public-read',
              content_type_starts_with: 'video',
              expires: ::Time.now + 1.hour
            )
          end
        end
      end
    end
  end
end

RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  if properties.name == :mp4
    fields << RailsAdmin::Config::Fields::Types::S3File.new(parent, properties.name, properties)
    true
  else
    false
  end
end
