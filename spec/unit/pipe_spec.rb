require 'spec_helper'

describe 'Fife::Pipe' do
  let :file do
    Tempfile.new('dummy')
  end

  let :pipe do
    Fife::Pipe.new(file)
  end

  after :each do
    file.unlink
  end

  it 'returns a new Pipe' do
    p = pipe.pipe(-> f {f})
    p.class.should == Fife::Pipe
    p.should_not equal pipe
  end

  it 'does nothing to a closed file' do
    file.close
    p = pipe.pipe(proc {Tempfile.new('fake')})
    p.files[0].should == pipe.files[0]
  end

  it 'manipulates open file' do
    p = pipe.pipe(-> f {f.write('xxx'); f})
    p.files[0].tap(&:rewind).read.should == 'xxx'
  end

end