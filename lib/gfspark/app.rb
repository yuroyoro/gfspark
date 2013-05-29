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

    unless @url && @service && @section && @graph
      puts "Invalid Arguments"
      @valid = false
      return
    end

    detect_width_and_height!
    set_ssl_options!
  end

  def execute
    json    = fetch(:xport)
    summary = fetch(:summary)

    render(json, summary)
    true
  end

  def fetch(api)
    url = "#{@url}/#{api.to_s}/#{@service}/#{@section}/#{@graph}"
    queries = {}
    queries[:t]     = @options[:t] || "d"
    queries[:width] = @width
    queries[:from]  = @options[:from] if @options[:from].nil?
    queries[:to]    = @options[:to] if @options[:to].nil?

    json = fetch_json(url, {}, queries)
  end
end
