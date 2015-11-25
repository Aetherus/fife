require 'net/sftp'
require 'pathname'
require 'fileutils'

class Net::SFTP::Session
  def mkdir_p!(pathname)
    pathname = Pathname(pathname) unless pathname.is_a? Pathname
    pathname.descend do |path|
      mkdir!(path) rescue nil
    end
  end
end

class Fife::Storage::Sftp

  class UninitializedAttributes < RuntimeError; end

  REQUIRED_ATTRIBUTES = [:host, :user, :naming, :ssh_options, :remote_dir]

  def remote_dir(*value)
    return @remote_dir if value.empty?
    @remote_dir = Pathname(value[0])
  end

  (REQUIRED_ATTRIBUTES - [:remote_dir]).each do |attr|
    class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def #{attr}(*value)
        return @#{attr} if value.empty?
        @#{attr} = value[0]
      end
    RUBY
  end

  def initialize(&block)
    instance_eval &block
    uninitialized_attributes = REQUIRED_ATTRIBUTES.select{|attr| send(attr).nil?}
    raise UninitializedAttributes, uninitialized_attributes unless uninitialized_attributes.empty?
  end

  def store(io)
    remote_path = remote_dir.join(@naming.call(io))
    dir = remote_path.dirname
    Net::SFTP.start(host, user, ssh_options) do |sftp|
      sftp.mkdir_p!(dir)
      sftp.file.open(remote_path, 'w') { |f| IO.copy_stream(io.tap(&:rewind), f) }
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