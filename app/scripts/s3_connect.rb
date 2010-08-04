require 'rubygems'
require 'aws/s3'

AWS::S3::Base.establish_connection!(
  :access_key_id     => ENV["S3_ACCESS_KEY_ID"],
  :secret_access_key => ENV["S3_SECRET_ACCESS_KEY"]
)