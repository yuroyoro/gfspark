# -*- coding: utf-8 -*-
module Gfspark::Graph
  @height = 20

  BARS = ["  ",  "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" ]
  def bar(val, unit, non_fullwidth_font = false)
    n = (val.to_f/unit).ceil
    @height.times.map{|i|
      x = n - (i * 8)
      if x <= 0
        BARS.first
      else
        bar_symbol = if x < 8
          BARS[x]
        else
          BARS.last
        end
        bar_symbol += " " if non_fullwidth_font
        bar_symbol
      end
    }
  end

  def render(json, summary)
    rows = json['rows']
    max = rows.flatten.compact.max
    max_val = (max / 8).ceil * 8
    unit  = max_val / (@height * 8).to_f

    s = Time.at(json["start_timestamp"].to_i).strftime("%Y-%m-%d %H:%M:%S")
    e = Time.at(json["end_timestamp"].to_i).strftime("%Y-%m-%d %H:%M:%S")

    puts "  #{blue(json["column_names"].first)}"
    puts ""
    puts "    #{period_title}   #{s} - #{e}"
    puts ""

    result = []

    rows.flatten.map{|row| bar(row, unit, @options[:non_fullwidth_font])}.transpose.reverse.each_with_index do |row, i|
      i = (@height- i)
      label = i.even? ? sprintf("%.1f", unit * i * 8) : ""
      line = row.join
      if color = @options[:color]
        line = Term::ANSIColor.send(color, line)
      end
      result << "#{sprintf("%10s", label)} | #{line} |"
    end
    puts result.join("\n")
    puts ""

    sums = summary.first.last
    puts "    #{sprintf("cur: %.1f  ave: %.1f  max: %.1f  min %.1f", *sums)}"
  end

  def period_title
    case @options[:t]
      when "c", "sc" then sprintf(RANGES[@options[:t]], @options[:from], @options[:to])
      else RANGES[@options[:t]]
    end
  end

  RANGES = {
    "y"   => 'Year (1day avg)',
    "m"   => 'Month (2hour avg)',
    "w"   => 'Week (30min avg)',
    "3d"  => '3 Days (5min avg)',
    "s3d" => '3 Days (5min avg)',
    "d"   => 'Day (5min avg)',
    "sd"  => 'Day (1min avg)' ,
    "8h"  => '8 Hours (5min avg)',
    "s8h" => '8 Hours (1min avg)' ,
    "4h"  => '4 Hours (5min avg)',
    "s4h" => '4 Hours (1min avg)' ,
    "h"   => 'Hour (5min avg), ',
    "sh"  => 'Hour (1min avg)' ,
    "n"   => 'Half Day (5min avg)',
    "sn"  => 'Half Day (1min avg)',
    "c"   => "%s to $s",
    "sc"  => "%s to $s"
  }

  def range_arg?(t)
    RANGES.keys.include? t
  end
end
