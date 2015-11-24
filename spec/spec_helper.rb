require 'rubygems'
require 'bundler'
require 'tempfile'
require 'stringio'
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
  let(:ios) {
    [
        Tempfile.new(SecureRandom.uuid),
        File.open(File.expand_path('../samples/sample.txt', __FILE__), 'w+'),
        StringIO.open('', 'w+')
    ]
  }
  let(:pipe) { Fife(ios) }
  let(:tmpdir) {Pathname('/tmp/fife_test')}
  let(:storage) { Fife::Storage::Sftp.new('localhost', 'zhoumh', tmpdir, password: '1q2w3e4r5t') }

  after :each do
    ios.each do |io|
      io.close unless io.closed?
    end
    FileUtils.rmtree tmpdir
  end
end