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
  let(:files) { 3.times.map{Tempfile.new(SecureRandom.uuid)} }
  let(:pipe) { Fife::Pipe.new(files) }
  let(:tmpdir) {Pathname('/tmp/fife_test')}

  before :each do
    Fife.storage = Fife::Storage::SFTP.new('localhost', 'zhoumh', tmpdir, password: '1q2w3e4r5t')
  end

  after :each do
    files.each do |f|
      begin
        f.unlink
      ensure
        f.close!
      end
    end
    FileUtils.rmtree tmpdir
  end
end