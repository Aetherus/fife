require 'net/sftp'
require 'pathname'
require 'fileutils'

module Fife
  module Storage

    class SFTP
      attr_reader :host, :user, :dir, :ssh_options

      def initialize(host, user, dir, ssh_options)
        @host, @user, @ssh_options = host, user, ssh_options
        @dir = Pathname(dir)
        ensure_dir_presence!
      end

      def store(*files)
        stored = []
        Net::SFTP.start(host, user, ssh_options) do |sftp|
          files.flatten.each do |file|
            file.close unless file.closed?
            basename = File.basename(file.path)
            sftp.upload! file.path, dir.join(basename)
            stored << basename
            FileUtils.remove(file.path)
          end
        end
        stored
      end

      private
      def ensure_dir_presence!
        Net::SFTP.start(host, user, ssh_options) do |sftp|
          dir.descend do |path|
            sftp.mkdir!(path) rescue nil
          end
        end
      end
    end

  end
end