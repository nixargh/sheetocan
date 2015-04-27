#!/usr/bin/ruby
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

      params.on("-m N", "--month N", Integer, "show time spent at month with number N") do |month|
        options[:month] = month
      end

      params.on("-r", "--report", "show time spent during this day, week and month") do
        options[:report] = true
      end

      params.on("-t N", "--truncate N", Integer, "truncate timesheet to last number of lines") do |l_num|
        options[:trunk_to] = l_num
      end
    end.parse!

    options
  end
end

class TimeSheet
  attr_accessor :trunk_to, :month

  def initialize(ts_file)
    @ts_file = ts_file
    @calendar_file = "./calendar"
    @trunk_to = 1000
    t = Time.now
    _, _, _, @day, @month, @year, @wday = t.to_a
    @month if month
  end

  # Create report of time spent at this day, week and month
  #
  def report
    read
    truncate(@trunk_to)
    return day_spent, week_spent, month_spent
  end

  # Show number fo workday at month (default is current month)
  #
  def workdays_month(month=@month)
    read_calendar[month]
  end

  private

  # Read working hours calendar
  #
  def read_calendar
    calendar = Hash.new
    IO.read(@calendar_file).each_line do |line|
      month, work_days = line.split(':')
      calendar[month.to_i] = work_days.to_i
    end
    calendar
  end

  # Read timesheet and convert it to array of hashes
  #
  def read
    ts = IO.read(@ts_file)
    ts = ts.split("\n")
    @list = ts.inject([]) do |ts_table, line|
      if line.empty? || line.index("Revision") || line.index("#") == 0
        next(ts_table)
      end
      ts_hash = Hash.new
      ts_hash[:date], ts_hash[:stime], ts_hash[:etime], ts_hash[:queue], ts_hash[:rt], ts_hash[:desc] = line.split(",")
      next (ts_table) if ts_hash[:date].empty? || ts_hash[:stime].empty? || ts_hash[:etime].empty? || ts_hash[:queue].empty? || ts_hash[:rt].empty?
      ts_hash[:desc] = ts_hash[:desc].delete("\"")
      ts_hash[:year], ts_hash[:month], ts_hash[:day] = ts_hash[:date].split("-")
      ts_hash[:year], ts_hash[:month], ts_hash[:day] = ts_hash[:year].to_i, ts_hash[:month].to_i, ts_hash[:day].to_i
      ts_table << ts_hash
    end
    @list.reverse!
  end

  # Truncating list of timesheet lines to speed up calculating
  #
  def truncate(l_num)
    length = @list.length
    @list = @list[0..l_num - 1] if length > l_num
  end

  # Calculate minutes loged today
  #
  def day_spent
    return nil if (!@year && !@month && !@day)
    @list.inject(0) do |t_spent, line|
      if line[:year] == @year && line[:month] == @month && line[:day] == @day
        minutes = to_m(line[:etime]) - to_m(line[:stime])
        t_spent = t_spent + minutes
      else
        next(t_spent)
      end
    end     
  end

  # Calculate minutes loged this week
  #
  def week_spent
    return nil if (!@year && !@month && !@day && !@wday)
    @list.inject(0) do |t_spent, line|
      if line[:year] == @year && line[:month] == @month && line[:day] > (@day - @wday)
        minutes = to_m(line[:etime]) - to_m(line[:stime])
        t_spent = t_spent + minutes
      else
        next(t_spent)
      end
    end     
  end
  
  # Calculate minutes loged this month
  #
  def month_spent
    return nil if (!@year && !@month)
    @list.inject(0) do |t_spent, line|
      if line[:year] == @year && line[:month] == @month
        minutes = to_m(line[:etime]) - to_m(line[:stime])
        t_spent = t_spent + minutes
      else
        next(t_spent)
      end
    end     
  end

  # Convert time (HH:MM 24-h format) to number of minutes
  #
  def to_m(time)
    h, m = time.split(":")
    h.to_i * 60 + m.to_i
  end
end
###############################################################################
Dir.chdir(File.dirname(__FILE__))

opt = Options.new
options = opt.parse

# take last unparsed argument as timesheet file
ts = TimeSheet.new(ARGV[-1])

ts.trunk_to = options[:trunk_to] if options[:trunk_to]
ts.month = options[:month] if options[:month]

if options[:report]
#  ts.report.each {|time| puts time / 60 }
  puts "#{ts.report.map!{|time| (time / 60.0).round(2)}.join(', ')} (#{ts.workdays_month})"
end
