# frozen_string_literal: true

RSpec.describe LogParser::Analyser::UniqueVisitsCounter do
  describe '#each' do
    let(:entries) do
      [
        LogParser::Logfile::Entry.new('/login', '3.3.3.3'),
        LogParser::Logfile::Entry.new('/login', '1.1.1.1'),
        LogParser::Logfile::Entry.new('/logout', '1.1.1.1'),
        LogParser::Logfile::Entry.new('/login', '2.2.2.2'),
        LogParser::Logfile::Entry.new('/home', '2.2.2.2'),
        LogParser::Logfile::Entry.new('/login', '1.1.1.1'),
        LogParser::Logfile::Entry.new('/home', '1.1.1.1'),
      ]
    end

    it 'yields given block passing each path and number of its unique occurrences (based on ipaddr) in descending order' do
      visits_counter = described_class.new
      entries.each { |entry| visits_counter.count(entry) }
      counters = visits_counter.enum_for(:each).to_a

      expect(counters).to eq([
        ['/login', 3],
        ['/home', 2],
        ['/logout', 1]
      ])
    end
  end
end
