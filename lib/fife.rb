require 'fife/version'
require 'active_support/all'

module Fife
  extend ActiveSupport::Autoload

  autoload :Pipe
  autoload :Operations
  autoload :Storage
  autoload :HasName

  def self.pipe(*ios)
    Pipe.new(ios)
  end
end