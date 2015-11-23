module Fife
  class Pipe

    class ClosedIO < RuntimeError; end

    attr_reader :files

    def initialize(*files)
      @files = files
    end

    def pipe(op)
      new_files = []

      files.map do |file|
        Thread.new do
          file.rewind unless file.closed?
          op = file.closed? ? Operations::Noop : op
          new_files << op.call(file)
        end
      end.each(&:join)

      self.class.new(*new_files)
    end

  end
end