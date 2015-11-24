require 'spec_helper'

describe 'Fife::Operations::Rename' do
  include_examples 'mock'

  it 'changes file names' do
    pipe.pipe(-> io {io.write 'Lorem Ipsum'; io}).pipe(name).pipe(store)
    stored_files = Dir[tmpdir.join('*')]
    stored_files.count.should == ios.count
    stored_files.each do |f|
      File.read(f).should == 'Lorem Ipsum'
    end
  end
end