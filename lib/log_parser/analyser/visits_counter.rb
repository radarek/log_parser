# frozen_string_literal: true

module LogParser
  class Analyser
    class VisitsCounter
      def initialize
        @counters = Hash.new(0)
      end

      def count(entry)
        @counters[entry.path] += 1
      end

      def each(&block)
        @counters.sort_by { |_path, count| -count }.each(&block)
      end
    end
  end
end
