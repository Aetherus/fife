require 'net/sftp'
require 'pathname'
require 'fileutils'

class Fife::Storage::Sftp
  attr_reader :host, :user, :remote_dir, :ssh_options

  def initialize(host, user, remote_dir, ssh_options)
    @host, @user, @ssh_options = host, user, ssh_options
    @remote_dir = Pathname(remote_dir)
    ensure_remote_dir_presence!
  end

  def store(io)
    raise UnnamedIO unless io.respond_to? :name
    remote_path = remote_dir.join(io.name)
    Net::SFTP.start(host, user, ssh_options) do |sftp|
      sftp.file.open(remote_path, 'w') { |f| IO.copy_stream(io, f) }
    end
    io.close
  end

  private
  def ensure_remote_dir_presence!
    Net::SFTP.start(host, user, ssh_options) do |sftp|
      remote_dir.descend do |path|
        sftp.mkdir!(path) rescue nil
      end
    end
  end
end