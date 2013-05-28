class Gfspark::App
  include ::Gfspark::Config
  include ::Gfspark::Connection
  include ::Gfspark::Graph

  def initialize(args)
    @opt_parse_obj = opt_parser
    @options = {}
    try_url(args) || try_path(args) || try_default(args)

    unless @url && @service && @section && @graph_name
      raise "Invalid Arguments"
    end

    detect_width_and_height!
    set_ssl_options!
  end

  def execute
    json    = fetch(:xport)
    summary = fetch(:summary)

    render(json, summary)
  end

  def fetch(api)
    url = "#{@url}/#{api.to_s}/#{@service}/#{@section}/#{@graph}"
    queries = {}
    queries[:t]     = @optinos[:t] || "d"
    queries[:width] = @width
    queries[:from]  = @options[:from] if @options[:from].nil?
    queries[:to]    = @options[:to] if @options[:to].nil?

    json = fetch_json(url, {}, queries)
  end
end
