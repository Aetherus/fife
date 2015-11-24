class Fife::Pipe

  attr_reader :ios

  def initialize(ios)
    @ios = ios.flatten.tap(&:compact!)
  end

  def pipe(op, *args)
    op = Fife::Operations.const_get(op.to_s.camelize.to_sym).new(*args) unless op.respond_to? :call
    output = []

    ios.map { |io|
      Thread.new do
        output << op.call(io.tap(&:rewind))
      end
    }.each(&:join)

    self.class.new(output)
  end

end