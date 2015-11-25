require 'spec_helper'

describe 'Error handling' do
  let(:ios) {2.times.map{|i| StringIO.new('', 'w+').tap{|io| io.write i.to_s}}}
  let(:fife) {Fife(ios, abort_on_fail: true)}

  after :each do
    ios.each do |io|
      io.close unless io.closed?
    end
  end

  it 'aborts when some operation throws :halt' do
    expect {
      fife.pipe(-> io {throw :halt}).pipe(-> io {io.write 'xxx'; io})
    }.to raise_error(Fife::Pipe::Aborted)
    ios.each do |io|
      io.should be_closed
      io.size.should == 1
    end
  end

  it 'aborts when some operation raises standard error' do
    begin
      fife.pipe(-> io {raise StandardError}).pipe(-> io {io.write 'xxx'; io})
    rescue => e
      e.should be_a Fife::Pipe::Aborted
      e.causes.size.should == ios.size
      e.causes.each do |error|
        error.should be_a StandardError
      end
    end
    ios.each do |io|
      io.should be_closed
      io.size.should == 1
    end
  end

  it 'does not abort if all green' do
    expect {
      fife.pipe(-> io {io.write 'xxx'; io}).pipe(:close)
    }.not_to raise_error
    ios.count{|io| io.size > 1}.should == ios.size
  end

  it 'aborts all further operations if any operation halts' do
    expect {
      fife.pipe(-> io {throw :halt if io.read == '0'; io})
          .pipe(-> io {io.write 'xxx'; io})
    }.to raise_error(Fife::Pipe::Aborted)

    ios.each do |io|
      io.should be_closed
      io.size.should == 1
    end
  end

  it 'aborts all further operations if any operation raises error' do
    expect {
      fife.pipe(-> io {fail if io.read == '0'; io})
          .pipe(-> io {io.write 'xxx'; io})
    }.to raise_error(Fife::Pipe::Aborted)

    ios.each do |io|
      io.should be_closed
      io.size.should == 1
    end
  end
end