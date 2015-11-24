module Fife::Storage
  extend ActiveSupport::Autoload

  class UnnamedIO < RuntimeError; end

  autoload :Null
  autoload :Sftp
end