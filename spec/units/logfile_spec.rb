# frozen_string_literal: true

RSpec.describe LogParser::Logfile do
  describe '#initialize' do
    it 'stores passed path to file' do
      logfile = described_class.new('path/to/file')
      expect(logfile.path).to eq 'path/to/file'
    end
  end

  describe '#each_entry' do
    it 'raises FileNotFoundError error when file does NOT exist' do
      logfile = described_class.new('non-existing.log')
      expect { logfile.each_entry {} }.to raise_error(LogParser::Logfile::FileNotFoundError, "File 'non-existing.log' does not exist")
    end

    it 'raises ParseLineError error when encounter unparsable line' do
      logfile = described_class.new('spec/fixtures/unparsable.log')
      expect { logfile.each_entry {} }.to raise_error(LogParser::Logfile::ParseLineError, "Couldn't parse line 'foo'")
    end

    it 'yields given block passing entry object for each line' do
      logfile = described_class.new('spec/fixtures/webserver.log')
      entries = logfile.enum_for(:each_entry).to_a
      expect(entries.size).to eq 6
      expect(entries[0].path).to eq '/'
      expect(entries[0].ipaddr).to eq '1.2.3.4'
      expect(entries[1].path).to eq '/login'
      expect(entries[1].ipaddr).to eq '1.2.3.4'
    end
  end
end
