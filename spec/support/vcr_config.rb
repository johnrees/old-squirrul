require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
  config.ignore_hosts 'codeclimate.com', 'fonts.googleapis.com'

  Rails.application.secrets.each do |k,v|
    config.filter_sensitive_data("ENV[#{k}]") { v }
  end
end
