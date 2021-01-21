# frozen_string_literal: true

module LogParser
  class Analyser
    attr_reader :logfile

    Result = Struct.new(:visits_counter, :unique_visits_counter, keyword_init: true)

    def initialize(logfile)
      @logfile = logfile
    end

    def analyse
      visits_counter = VisitsCounter.new
      unique_visits_counter = UniqueVisitsCounter.new

      logfile.each_entry do |entry|
        visits_counter.count(entry)
        unique_visits_counter.count(entry)
      end

      Result.new(visits_counter: visits_counter, unique_visits_counter: unique_visits_counter)
    end
  end
end
