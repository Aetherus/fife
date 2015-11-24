require 'pathname'
require 'fileutils'

module Fife
  module Operations

    class Name

      class NoBlockGiven < RuntimeError; end

      def initialize(&block)
        raise NoBlockGiven unless block_given?
        @naming = block
      end

      def call(io)
        io.extend(HasName)
        io.name = @naming.call(io)
        io
      end

    end

  end
end