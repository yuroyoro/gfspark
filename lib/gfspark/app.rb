# -*- coding: utf-8 -*-
class Gfspark::App
  include Term::ANSIColor
  include ::Gfspark::Config
  include ::Gfspark::Connection
  include ::Gfspark::Graph

  attr_accessor :debug, :options, :valid

  def initialize(args)
    @opt_parse_obj = opt_parser

    if args.nil? || args.empty?
      @valid = false
      return
    end

    @options = load_default_settings
    try_url(args) || try_path(args) || try_default(args)

    required_args = [:url, :service, :section, :graph]
    unless required_args.map(&:to_s).map(&"@".method(:+)).map(&method(:instance_variable_get)).inject(true, :&)
      puts "Invalid Arguments: check arguments or your .gfspark file"
      required_args.each do |n|
        puts "  #{n} is required" unless instance_variable_get("@#{n}")
      end
      puts ""
      @valid = false
      return
    end

    @options[:t] ||= "d"
    unless RANGES.keys.include?(@options[:t])
      puts "Unknown graph range t=#{@options[:t]}"
      @valid = false
      return
    end

    @options[:y_axis_label] ||= "show"
    @valid = true
    detect_width_and_height!
    set_ssl_options!
  end

  def execute
    json    = fetch(:xport)
    summary = fetch(:summary)

    url = to_url(:view_graph)
    render(json, summary, url)
    true
  end

  def to_url(api)
    url = "#{@url}/#{api.to_s}/#{@service}/#{@section}/#{@graph}"
    queries = {}
    queries[:t]     = @options[:t] || "d"
    queries[:width] = @width
    queries[:gmode] = @options[:gmode] if @options[:gmode]
    queries[:from]  = @options[:from]  if @options[:from]
    queries[:to]    = @options[:to]    if @options[:to]
    "#{url}?#{queries.map{|k,v| "#{k}=#{v}"}.join("&")}"
  end

  def fetch(api)
    url = "#{@url}/#{api.to_s}/#{@service}/#{@section}/#{@graph}"
    queries = {}
    queries[:t]     = @options[:t] || "d"
    queries[:width] = @width
    queries[:gmode] = @options[:gmode] if @options[:gmode]
    queries[:from]  = @options[:from]  if @options[:from].nil?
    queries[:to]    = @options[:to]    if @options[:to].nil?

    json = fetch_json(url, {}, queries)
  end
end
