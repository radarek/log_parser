# frozen_string_literal: true

module LogParser
  class Main
    attr_reader :argv

    def initialize(argv)
      @argv = argv
    end

    def run
      if argv.size == 1
        print_statistics
      else
        print_usage
        exit(1)
      end
    rescue LogParser::Error => e
      $stderr.puts "Something went wrong: #{e.message}"
      exit(2)
    end

    private

    def print_usage
      puts <<~TEXT
        Usage: #{$PROGRAM_NAME} <LOGFILE>

        Analyse <LOGFILE> file and prints number of views and unique views.
      TEXT
    end

    def print_statistics
      file_path = argv[0]

      logfile = Logfile.new(file_path)
      result = Analyser.new(logfile).analyse

      result.visits_counter.each do |path, count|
        puts "#{path} #{count} visits"
      end

      puts

      result.unique_visits_counter.each do |path, count|
        puts "#{path} #{count} unique views"
      end
    end
  end
end
