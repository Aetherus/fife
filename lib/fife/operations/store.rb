module Fife
  module Operations

    class Store
      attr_reader :storage

      def initialize(storage)
        @storage = storage
      end

      def call(io)
        storage.store(io)
      end

    end

  end
end