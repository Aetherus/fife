require "fife/version"

module Fife
  autoload :Pipe, 'fife/pipe'
  autoload :Operations, 'fife/operations'
  autoload :Storage, 'fife/storage'
  autoload :RenamedFile, 'fife/renamed_file'

  class << self
    attr_accessor :storage
  end
end
