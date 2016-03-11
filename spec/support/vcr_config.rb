require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
  config.ignore_hosts 'codeclimate.com', 'fonts.googleapis.com'

  keys = ENV.keys.select{ |a| a.match(/\A_FIGARO_/) }
  keys = keys.map{|k| k.gsub("_FIGARO_","") }

  keys.each do |key|
    config.filter_sensitive_data("ENV[#{key}]") { ENV.fetch(key) }
  end
end
