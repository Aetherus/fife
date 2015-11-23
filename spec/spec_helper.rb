require "rubygems"
require "bundler"
require "tempfile"
Bundler.require(:default, :test)

$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
$LOAD_PATH.unshift(File.expand_path('..', __FILE__))

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :should
  end
  config.mock_with :rspec do |c|
    c.syntax = :should
  end
end