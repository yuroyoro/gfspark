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

  def seconds_to_label(sec)
    t = Time.at(sec).utc
    d, h, m, s = t.day.pred, t.hour, t.min, t.sec
    res = ""
    res += "#{d}day" unless d.zero?
    res += "#{h}h"   unless h.zero? && (d.zero? || (m.zero? && s.zero?))
    res += "#{m}min" unless m.zero? && ((d.zero? && h.zero?) || s.zero?)
    res += "#{s}sec" unless s.zero?
    return res
  end

  def render(json, summary, url = nil)
    rows    = json['rows']
    step    = json['step'].to_i
    max     = rows.flatten.compact.max
    max_val = (max / 8).ceil * 8
    unit    = max_val / (@height * 8).to_f

    start_timestamp = json["start_timestamp"].to_i
    end_timestamp   = json["end_timestamp"].to_i
    s = Time.at(start_timestamp).localtime.strftime("%Y-%m-%d %H:%M:%S")
    e = Time.at(end_timestamp  ).localtime.strftime("%Y-%m-%d %H:%M:%S")

    puts "  #{blue(json["column_names"].first)}"
    puts "    #{yellow(url)}"
    puts ""
    puts "    #{period_title}   #{s} - #{e}  step: /#{seconds_to_label(step)}"
    puts ""

    result = []

    rows.flatten.map{|row| bar(row, unit, @options[:non_fullwidth_font])}.transpose.reverse.each_with_index do |row, i|
      i = (@height- i)
      label = i.even? ? sprintf("%.1f", unit * i * 8) : ""
      line = row.join
      if color = @options[:color]
        line = Term::ANSIColor.send(color, line)
      end
      result << "#{sprintf("%10s", label)} |#{line}|"
    end
    puts result.join("\n")

    render_y_axis_labels(rows, start_timestamp, step)

    puts ""

    sums = summary.first.last
    puts "    #{sprintf("cur: %.1f  ave: %.1f  max: %.1f  min %.1f", *sums)}"
  end

  def render_y_axis_labels(rows, start_timestamp, step)
    y_axis_labels = rows.length.times.select{|n| n % 4 == 0}. map{|n|
      t = Time.at(start_timestamp + (n * step)).localtime
      sprintf("%-8s", to_axis_label(t))
    }.join
    y_axis_arrows= rows.length.times.select{|n| n % 4 == 0}. map{|n|
      " /      "
    }.join

    case @options[:y_axis_label]
      when "show"
        puts sprintf("%10s%s", "", y_axis_arrows)
        puts sprintf("%10s%s", "", y_axis_labels)
      when "simple"
        puts sprintf("%10s%s", "", y_axis_labels)
     end
  end

  def axis_unit
    @axis_unit ||= RANGE_DEFS.find{|_| _.first == @options[:t]}.last
  end

  def to_axis_label(t)
    case axis_unit
      when :min   then t.strftime("%M")
      when :hour  then t.strftime("%H:%M")
      when :day   then t.strftime("%d")
      when :week  then t.strftime("%a")
      when :month then t.strftime("%m")
      else             t.strftime("%H:%M")
    end
  end

  def period_title
    case @options[:t]
      when "c", "sc" then sprintf("%s to %s", @options[:from], @options[:to])
      else RANGES[@options[:t]]
    end
  end

  RANGE_DEFS = [
    # option, label, y-axis unit
    ["y"   , 'Year (1day avg)'     , :month],
    ["m"   , 'Month (2hour avg)'   , :day  ],
    ["w"   , 'Week (30min avg)'    , :week ],
    ["3d"  , '3 Days (5min avg)'   , :hour ],
    ["s3d" , '3 Days (5min avg)'   , :hour ],
    ["d"   , 'Day (5min avg)'      , :hour ],
    ["sd"  , 'Day (1min avg)'      , :hour ],
    ["8h"  , '8 Hours (5min avg)'  , :hour ],
    ["s8h" , '8 Hours (1min avg)'  , :hour ],
    ["4h"  , '4 Hours (5min avg)'  , :hour ],
    ["s4h" , '4 Hours (1min avg)'  , :hour ],
    ["h"   , 'Hour (5min avg)'     , :min  ],
    ["sh"  , 'Hour (1min avg)'     , :min  ],
    ["n"   , 'Half Day (5min avg)' , :hour ],
    ["sn"  , 'Half Day (1min avg)' , :hour ],
    ["c"   , "Custom (5min avg)"   , :min  ],
    ["sc"  , "Custom (1min avg)"   , :min  ]
  ]
  RANGES = Hash[*RANGE_DEFS.map{|k,v,_| [k,v]}.flatten]

  def range_arg?(t)
    RANGES.keys.include? t
  end
end
