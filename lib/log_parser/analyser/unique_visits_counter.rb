# frozen_string_literal: true

require 'set'

module LogParser
  class Analyser
    class UniqueVisitsCounter
      def initialize
        @counters = Hash.new(0)
        @visitors = Hash.new { |hash, key| hash[key] = Set.new }
      end

      def count(entry)
        return if already_counted?(entry)
        @visitors[entry.path].add(entry.ipaddr)
        @counters[entry.path] += 1
      end

      def each(&block)
        @counters.sort_by { |_path, count| -count }.each(&block)
      end

      private

      def already_counted?(entry)
        @visitors[entry.path].include?(entry.ipaddr)
      end
    end
  end
end
