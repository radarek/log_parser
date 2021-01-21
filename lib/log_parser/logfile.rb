# frozen_string_literal: true

module LogParser
  class Logfile
    class FileNotFoundError < Error; end
    class ParseLineError < Error; end

    Entry = Struct.new(:path, :ipaddr)

    attr_reader :path

    def initialize(path)
      @path = path
    end

    def each_entry
      File.foreach(path, "\n", chomp: true) do |line|
        yield parse_line(line)
      end
    rescue Errno::ENOENT
      raise FileNotFoundError, "File '#{path}' does not exist"
    end

    private

    def parse_line(line)
      path, ipaddr = line.split(' ', 2)
      raise ParseLineError, "Couldn't parse line '#{line}'" if ipaddr.nil?
      Entry.new(path, ipaddr)
    end
  end
end
