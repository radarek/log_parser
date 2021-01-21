# frozen_string_literal: true

RSpec.describe LogParser::Analyser do
  let(:logfile) { LogParser::Logfile.new('spec/fixtures/webserver.log') }

  it 'is initialized with logfile' do
    analyser = described_class.new(logfile)
    expect(analyser.logfile).to eq logfile
  end

  describe '#analyse' do
    let(:visits_counter) { double('visits_counter') }
    let(:unique_visits_counter) { double('unique_visits_counter') }

    subject { described_class.new(logfile) }

    it 'passess each logfile entry to visits counter' do
      expect(LogParser::Analyser::VisitsCounter).to receive(:new).and_return(visits_counter)
      expect(visits_counter).to receive(:count).exactly(6).times

      subject.analyse
    end

    it 'passess each logfile entry to unique visits counter' do
      expect(LogParser::Analyser::UniqueVisitsCounter).to receive(:new).and_return(unique_visits_counter)
      expect(unique_visits_counter).to receive(:count).exactly(6).times

      subject.analyse
    end

    it 'returns result object with counter' do
      result = subject.analyse

      expect(result.visits_counter).to be_instance_of(LogParser::Analyser::VisitsCounter)
      expect(result.unique_visits_counter).to be_instance_of(LogParser::Analyser::UniqueVisitsCounter)
    end
  end
end
