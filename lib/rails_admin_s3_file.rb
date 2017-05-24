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

          def initialize(*args, &block)
            Aws.config.update(
              region: ENV['AWS_REGION'] || 'us-east-1',
              credentials: Aws::Credentials
                .new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
            )

            super *args, &block
          end

          register_instance_option(:partial) do
    	      :form_s3_file
    	    end

          register_instance_option(:upload_path) do
            'rails_admin_s3_uploads'
    	    end

          register_instance_option(:upload_extension) do
            'mp4'
    	    end

          register_instance_option(:upload_acl) do
            'public-read'
    	    end

          register_instance_option(:upload_content_type) do
            'video'
          end

          def upload_key
            @upload_key ||= "#{upload_path}/#{SecureRandom.uuid}.#{upload_extension}"
          end

          def s3_bucket
            @bucket ||= Aws::S3::Resource.new.bucket(ENV['FOG_DIRECTORY'])
          end

          def presigned_post
            s3_bucket.presigned_post(
              key: upload_key,
              acl: upload_acl,
              content_type_starts_with: upload_content_type,
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
