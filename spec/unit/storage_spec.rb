require 'spec_helper'

describe 'Fife::Operations::Rename' do
  include_examples 'mock'

  it 'changes file names' do
    pipe.pipe(name).pipe(store)
    Dir[tmpdir.join('*')].should_not be_empty
  end
end