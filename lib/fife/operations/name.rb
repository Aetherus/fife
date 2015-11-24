require 'pathname'
require 'fileutils'

class Fife::Operations::Name
  def initialize(naming)
    @naming = naming
  end

  def call(io)
    io.extend(Fife::HasName)
    io.name = @naming.call(io)
    io
  end
end