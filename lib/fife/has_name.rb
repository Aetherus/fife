module Fife::HasName
  def self.extended(obj)
    class << obj
      attr_reader :name unless instance_methods(true).include? :name
      attr_writer :name unless instance_methods(true).include? :name=
    end
  end
end