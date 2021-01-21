# Webserver log parser

## Description

This repository contains simple script which can parse webserver log (see format below) and output number of views and unique visits for each path from the file.

## Setup

Check if you have proper Ruby version installed on your system.

```
$ cat .ruby-version
2.7.2
$ ruby -v
ruby 2.7.2p137 (2020-10-01 revision 5445e04352) [x86_64-darwin19]
```

Install gems through bundler

```
$ bundler install
```

## Usage

```
bin/parser
Usage: bin/parser <LOGFILE>

Analyse <LOGFILE> file and prints number of views and unique views.
```

Example:

```
$ bin/parser sample_logs/webserver.log
/about/2 90 visits
/contact 89 visits
/index 82 visits
/about 81 visits
/help_page/1 80 visits
/home 78 visits

/help_page/1 23 unique views
/contact 23 unique views
/home 23 unique views
/index 23 unique views
/about/2 22 unique views
/about 21 unique views
```

## Running specs

No additional setup is required. Just run specs with a command:

```
$ bundler exec rpsec
```

Code coverage report is generated in `coverage/` directory.
Please note that file `lib/log_parser/main.rb` isn't reported accurately because it is testes through spawning new process thus code coverage can't be gathered.

## Implementation notes

None of provided ip addresses in the file webserver.log is correct so I assumed that checking validity of data is out of scope.
Code was divided in couple of classes:

* `LogParser::Main` - run from the executable script. Receive command line arguments and do appropriate action (either show statistics or print usage info).
* `LogParser::Logfile` - represents log file. It can open the given file, iterate over each line and yield it as `LogParser::Entry` object.
* `LogParser::Analyser` - receive `LogParser::Logfile`, for each entry it counts number of views and unique visits (using `LogParser::Analyser::VisitsCounter` and `LogParser::Analyser::UniqueVisitsCounter` classes).
