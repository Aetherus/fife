require 'spec_helper'

describe 'Fife::Storage::SFTP' do
  include_examples 'mock'

  # let(:tmpdir) {Pathname('/tmp/fife_test')}
  # let(:files) { 3.times.map{ Tempfile.new(SecureRandom.uuid).tap{|f| f.write 'SFTP TEST'} } }
  # let(:pipe) { Fife::Pipe.new(files).pipe(Fife::Operations::Close) }

  before :each do
    files.each { |f| f.write('SFTP TEST') }
    pipe.files.each(&:close)
  end

  it 'stores files and returns their names' do
    filenames = pipe.store
    files.each do |file|
      File.read(tmpdir.join File.basename(file.path)).should == 'SFTP TEST'
    end
    filenames.should == files.map{|f| File.basename(f.path)}
  end
end