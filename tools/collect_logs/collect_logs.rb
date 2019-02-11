#!/usr/bin/env ruby

require 'etc'
require 'pg'
require 'fileutils'

puts "Would you like to collect archive or current logs?"

timestamp = Time.new

# set log collect directory
collect_logs_directory = "/var/www/miq/vmdb"

# eliminate any prior collected logs to make sure that only one collection is current
FileUtils.rm Dir.glob("#{collect_logs_directory}/log/evm_{full_archive,archived}_#{Etc.uname[:nodename]}*") 

tarball = "log/evm_archive_#{Etc.uname[:nodename]}_#{timestamp.strftime('%Y%m%d_%H%M%S')}.tar.xz"

Dir.mkdir(collect_logs_directory) unless File.exists?(collect_logs_directory)
Dir.chdir(collect_logs_directory) do
  if !ENV['APPLIANCE_PG_DATA'].nil? and File.directory?("#{ENV['APPLIANCE_PG_DATA']}/pg_log")
    v = PG.library_version
    puts "This ManageIQ appliance has a Database server and is running version: psql (PostgreSQL) #{v / 10000}.#{(v % 10000) / 100}.#{(v % 100)}"

  else
    puts "This ManageIQ appliance is not a Database server"
    puts "Log collection starting:"

  end
end

puts "Archive Written To: #{collect_logs_directory}/#{tarball}"
