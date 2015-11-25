class Fife::Pipe

  class Aborted < RuntimeError
    attr_reader :causes

    def initialize(causes=[])
      @causes = causes
    end
  end

  attr_reader :ios, :abort_on_fail

  def initialize(ios, abort_on_fail)
    @ios = ios
    @abort_on_fail = abort_on_fail
  end

  def pipe(op, *args)
    op = Fife::Operations[op].new(*args) unless op.respond_to? :call
    output = []

    ios.map { |io|
      Thread.new do
        output << catch(:halt) do
          begin
            op.call(io.tap(&:rewind))
          rescue => e
            throw :halt, e
          end
        end
      end
    }.each(&:join)

    errors, output = output.tap(&:flatten!).partition{|o| o.is_a?(StandardError)}

    should_abort = abort_on_fail && (errors.any? || output.any?(&:nil?))
    if should_abort
      ios.each { |io| io.close unless io.closed? }
      raise Aborted, errors
    end

    self.class.new(output.tap(&:compact!), abort_on_fail)
  end

end