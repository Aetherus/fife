require 'rubygems'
require 'bundler'
require 'tempfile'
require 'stringio'
require 'securerandom'
require 'fileutils'
Bundler.require(:default, :test)

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
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
  let(:storage) {
    remote_dir = tmpdir
    user = `whoami`.strip
    Fife::Storage::Sftp.new do
      host 'localhost'
      user user
      ssh_options keys: ["/home/#{user}/.ssh/id_rsa"], auth_methods: ['publickey']
      remote_dir remote_dir
      naming proc{SecureRandom.uuid}
    end
  }

  after :each do
    ios.each do |io|
      io.close unless io.closed?
    end
    FileUtils.rmtree tmpdir
  end
end