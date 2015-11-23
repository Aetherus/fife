module Fife
  class Flow
    def initialize(*ops)
      @ops = ops
    end

    def go(*files)
      @ops.reduce(Pipe.new(*files)){|pipe, op| pipe.pipe(op)}.files
    end
  end

  def self.line_up(*ops)
    Flow.new(*ops.push(Operators::Close))
  end
end