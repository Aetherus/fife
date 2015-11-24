require 'spec_helper'

describe 'Fife::Pipe' do
  include_examples 'mock'

  it 'returns a new Pipe' do
    p = pipe.pipe(-> f {f})
    p.class.should == Fife::Pipe
    p.should_not equal pipe
  end

  # it 'does nothing to closed files' do
  #   files.sample.close
  #   closed_files = files.select(&:closed?)
  #   p = pipe.pipe(-> f {Tempfile.new(SecureRandom.uuid).tap(&:close)})
  #   (p.ios & files).should == closed_files
  # end

  it 'manipulates open files' do
    p = pipe.pipe(-> f {f.write('xxx'); f})
    p.ios.each do |f|
      f.rewind
      f.read.should == 'xxx'
    end
  end

end