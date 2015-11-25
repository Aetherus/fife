module Fife::Operations
  extend ActiveSupport::Autoload

  autoload :Noop
  autoload :Close
  autoload :Name
  autoload :Store

  @registered = ActiveSupport::HashWithIndifferentAccess.new

  def self.register(name, operation_class)
    @registered[name] = operation_class
  end

  def self.[](name)
    @registered[name] ||= const_get(name.to_s.camelize)
  end
end