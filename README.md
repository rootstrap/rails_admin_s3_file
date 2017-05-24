# RailsAdminS3File
Short description and motivation.

## Usage

- Add a new field to your model as string.
- Configure the field on your rails_admin.rb initializer

```
field :your_field, :s3_file do
  upload_path  "#{ENV['AWS_ENV']}/videos/" # mandatory
  upload_extension 'mp4'                   # mandatory
  upload_content_type 'video'              # Optional default video
  upload_acl 'public-read'                 # Optional default public-read options
end
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'rails_admin_s3_file'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install rails_admin_s3_file
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
