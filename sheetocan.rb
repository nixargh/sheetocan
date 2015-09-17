#!/usr/bin/ruby
###############################################################################
#### INFO ######################################################################
# Sheetocan - tool for timesheet operations.
# (*w) author: nixargh <nixargh@gmail.com>
VERSION = '1.2.1'
#### LICENSE ###################################################################
#Copyright (C) 2014  nixargh <nixargh@gmail.com>
#
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see http://www.gnu.org/licenses/gpl.html.
#### REQUIRE ###################################################################
require 'optparse'
#### CLASES ####################################################################
class Options

  # Parse command line arguments
  #
  def parse
    options = Hash.new(false)

    OptionParser.new do |params|
      params.banner = "Sheetocan v.#{VERSION}.\nUsage: #{__FILE__} [options]"
      
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

      params.on("-b F", "--bubbles F", Float, "show non-working time in current day between first and last time worked") do |bubble_limit|
        if bubble_limit
          options[:bubbles] = bubble_limit
        else
          options[:bubbles] = 24.0
        end
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
    exit 1 if !validate_list
    return day_spent, week_spent, month_spent
  end

  # Only validate timesheet
  #
  def validate
    read
    truncate(@trunk_to)
    exit 1 if !validate_list
  end

  # Return bubbles minutes
  #
  def bubbles(limit)
    if @list.empty?
      raise "No timesheet content found."
    end
    calculate_bubbles(limit)
  end

  # Show number of workhours at month (default is current month)
  #
  def workhours_month(month=@month)
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
    line_number = 0
    @list = ts.inject([]) do |ts_table, line|
      line_number = line_number + 1
      # Skip empty lines and comments
      if line.empty? || line.index("Revision") || line.index("#") == 0
        next(ts_table)
      end

      ts_hash = Hash.new
      ts_hash[:number] = line_number
      ts_hash[:date], ts_hash[:stime], ts_hash[:etime], ts_hash[:queue], ts_hash[:rt], ts_hash[:desc] = line.split(",")

      # End time 00:00 is also valid and should be equal to 24:00
      ts_hash[:etime] = "24:00" if ts_hash[:etime] == "00:00"
      
      # Go to next line if something except description is empty
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

  # Do some validations of lines data
  #
  def validate_list
    list = @list.reverse
    bad_lines = Array.new
    list.each_index do |i|
      cur_line = list[i]
      # Record lines where end time more or equal to start time
      bad_lines.push([cur_line[:number], "Start time >= than end time"]) if to_m(cur_line[:etime]) <= to_m(cur_line[:stime])

      if i > 0
        pre_line = list[i - 1]
        # Record lines where start time more or equal to end time of previous line
        if cur_line[:year] < pre_line[:year]
          bad_lines.push([cur_line[:number], "Year < than year of previous record"])
        elsif cur_line[:year] == pre_line[:year]
          if cur_line[:month] < pre_line[:month]
            bad_lines.push([cur_line[:number], "Month < than month of previous record"])
          elsif cur_line[:month] == pre_line[:month]
            if cur_line[:day] < pre_line[:day]
              bad_lines.push([cur_line[:number], "Day < than day of previous record"])
            elsif cur_line[:day] == pre_line[:day]
              bad_lines.push([cur_line[:number], "Start time < than end time of previous record"]) if to_m(cur_line[:stime]) < to_m(pre_line[:etime])
            end
          end
        end
      end
    end

    if !bad_lines.empty?
      puts "Failed to validate timesheet with following errors:"
      bad_lines.each do |error|
        puts "\t#{error[0]}: #{error[1]}"
      end

      return false
    end

    return true
  end

  # Calculate free minutes between busy periods during day
  #
  def calculate_bubbles(limit)
    return nil if (!@year && !@month && !@day)

    list = @list.reverse
    free_min = 0

    list.reverse.each_index do |i|
      cur_line = list[i]

      if i > 0
        pre_line = list[i - 1]
        if cur_line[:year] == @year && cur_line[:month] == @month && cur_line[:day] == @day &&
          pre_line[:year] == @year && pre_line[:month] == @month && pre_line[:day] == @day

          minutes = to_m(cur_line[:stime]) - to_m(pre_line[:etime])

          if minutes < limit
            free_min = free_min + minutes
          end
        end
      end
    end     

    free_min
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
#### BEGIN ####################################################################
Dir.chdir(File.dirname(__FILE__))

# Check ruby version
if RUBY_VERSION.delete('.').to_i < 190
  puts("#{RUBY_VERSION} is unsupported. Please use ruby 1.9.0 or newer.")
  exit 1
end

opt = Options.new
options = opt.parse

# take last unparsed argument as timesheet file
ts = TimeSheet.new(ARGV[-1])

ts.trunk_to = options[:trunk_to] if options[:trunk_to]
ts.month = options[:month] if options[:month]

if options[:report]
  day_spent, week_spent, month_spent = ts.report
  hours_to_work = ts.workhours_month
  bubbles = options[:bubbles] ? " [#{(ts.bubbles(options[:bubbles] * 60) / 60.0).round(2)}]" : nil
  puts "#{[day_spent, week_spent, month_spent].map!{|time| (time / 60.0).round(2)}.join(', ')} (#{hours_to_work}, #{(month_spent / 60) - hours_to_work})#{bubbles}"
else
  ts.validate
  puts "No errors found."
end

exit 0
