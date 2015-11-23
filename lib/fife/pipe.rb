module Fife
  class Pipe

    attr_reader :files

    def initialize(*files)
      @files = files.flatten
    end

    def pipe(op)
      output = []

      files.map { |file|
        Thread.new do
          output << if file.closed?
            Operations::Noop.call(file)
          else
            op.call(file.tap(&:rewind))
          end
        end
      }.each(&:join)

      self.class.new(output)
    end

  end
end