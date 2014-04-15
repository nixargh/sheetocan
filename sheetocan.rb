#!/usr/bin/ruby1.9.3
###############################################################################
class Options
  require 'optparse'

  # Parse command line arguments
  #
  def parse
    options = Hash.new(false)

    OptionParser.new do |params|
      params.banner = "Usage: #{__FILE__} [options]"
      
      params.on("-h", "--help", "show this message") do
        options[:help] = true
        puts params
        exit 0
      end

      params.on("-r", "--report", "show time spent during this day, week and month") do
        options[:report] = true
      end

    end.parse!

    options
  end
end

class TimeSheet
  def initialize(ts_file)
    @ts_file = ts_file
  end

  # Create report of time spent at this day, week and month
  #
  def report
    puts read
  end

  private

  # Read timesheet and convert it to array of hashes
  #
  def read
    ts = IO.read(@ts_file)
    ts = ts.split("\n")
    ts.inject([]) do |ts_table, line|
      if line.empty? || line.index("Revision") || line.index("#") == 0
        next(ts_table)
      end
      ts_hash = Hash.new
      ts_hash[:date], ts_hash[:stime], ts_hash[:etime], ts_hash[:queue], ts_hash[:rt], ts_hash[:desc] = line.split(",")
      ts_hash[:desc] = ts_hash[:desc].delete("\"")
      ts_table << ts_hash
    end
  end

end
###############################################################################

opt = Options.new
options = opt.parse

# take last unparsed argument as timesheet file
ts = TimeSheet.new(ARGV[-1])
if options[:report]
  ts.report
end
