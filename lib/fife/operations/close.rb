class Fife::Operations::Close
  def call(io)
    io.close unless io.closed?
    io
  end
end