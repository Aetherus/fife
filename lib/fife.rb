require 'fife/version'
require 'active_support/all'

module Fife
  extend ActiveSupport::Autoload

  autoload :Pipe
  autoload :Operations
  autoload :Storage
  autoload :HasName
end