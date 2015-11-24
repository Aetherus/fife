class Fife::Pipe

  attr_reader :ios

  def initialize(*ios)
    @ios = ios.flatten.tap(&:compact!)
  end

  def pipe(op)
    output = []

    ios.map { |io|
      Thread.new do
        output << op.call(io.tap(&:rewind))
      end
    }.each(&:join)

    self.class.new(output)
  end

end