require 'pathname'
require 'fileutils'

module Fife
  module Operations

    class Rename

      class NoBlockGiven < RuntimeError; end

      def initialize(&block)
        raise NoBlockGiven unless block_given?
        @naming = block
      end

      def call(file)
        new_path = Pathname(File.dirname(file.path)).join(@naming.call(file))
        file.close
        FileUtils.move(file.path, new_path)
        File.open(new_path)
      end

    end

  end
end