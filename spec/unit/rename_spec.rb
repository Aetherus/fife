require 'spec_helper'

describe 'Fife::Operations::Rename' do
  include_examples 'mock'

  let(:rename) {
    i = 0
    Fife::Operations::Rename.new do
      (i += 1).to_s
    end
  }

  it 'changes file names' do
    pipe.pipe(rename).store
    files.count.times do |i|
      Dir[tmpdir.join (i + 1).to_s].should_not be_empty
    end
  end
end