require 'rubygems'
require 'bundler'
require 'tempfile'
require 'securerandom'
require 'fileutils'
Bundler.require(:default, :test)

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :should
  end
  config.mock_with :rspec do |c|
    c.syntax = :should
  end
end

RSpec.shared_examples 'mock' do
  let(:ios) { 3.times.map{Tempfile.new(SecureRandom.uuid)} }
  let(:pipe) { Fife::Pipe.new(ios) }
  let(:tmpdir) {Pathname('/tmp/fife_test')}
  let(:storage) { Fife::Storage::Sftp.new('localhost', 'zhoumh', tmpdir, password: '1q2w3e4r5t') }
  let(:store) { Fife::Operations::Store.new(storage) }
  let(:name) { Fife::Operations::Name.new { SecureRandom.uuid } }

  after :each do
    ios.each do |f|
      begin
        f.unlink
      ensure
        f.close!
      end
    end
    FileUtils.rmtree tmpdir
  end
end