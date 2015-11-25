require 'fife/version'
require 'active_support/all'

module Fife
  extend ActiveSupport::Autoload

  autoload :Pipe
  autoload :Operations
  autoload :Storage
  autoload :HasName
end

module Kernel
  def Fife(*ios, abort_on_fail: false)
    Fife::Pipe.new(ios.tap(&:flatten!).tap(&:compact!), abort_on_fail)
  end
end
