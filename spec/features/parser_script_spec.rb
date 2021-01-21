# frozen_string_literal: true

RSpec.describe 'Parser script (bin/parser)' do
  context 'when no options are provided' do
    it 'displays usage text' do
      expect { system('bin/parser') }.to output(<<~TEXT).to_stdout_from_any_process
        Usage: bin/parser <LOGFILE>

        Analyse <LOGFILE> file and prints number of views and unique views.
      TEXT
    end

    it 'exits with status 1' do
      `bin/parser`
      expect($?.exitstatus).to eq 1
    end
  end

  context 'when logfile file is provided' do
    context 'when logfile is unparsable' do
      it 'prints error message to stderr' do
        expect { system('bin/parser spec/fixtures/unparsable.log') }.to output(<<~TEXT).to_stderr_from_any_process
          Something went wrong: Couldn't parse line 'foo'
        TEXT
      end

      it 'exits with status 2' do
        `bin/parser spec/fixtures/unparsable.log`
        expect($?.exitstatus).to eq 2
      end
    end

    context 'when logfile is parsable' do
      it 'prints statistics from analyser for provided file path' do
        expect { system('bin/parser spec/fixtures/webserver.log') }.to output(<<~TEXT).to_stdout_from_any_process
          / 2 visits
          /login 2 visits
          /logout 1 visits
          /home 1 visits

          / 2 unique views
          /login 2 unique views
          /logout 1 unique views
          /home 1 unique views
        TEXT
      end

      it 'exits with status 0' do
        `bin/parser spec/fixtures/webserver.log`
        expect($?.exitstatus).to eq 0
      end
    end
  end
end
