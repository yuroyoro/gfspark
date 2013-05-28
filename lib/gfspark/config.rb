module Gfspark::Config

  def try_url(args)
    return false unless args.first =~ /http?/

    u = URI.parse(args.shift)
    @url = u.to_s.gsub(u.request_uri, '')
    @graph, @section, @service = u.path.split('/').reverse
    if u.query
      queries = Hash[*u.query.split("&").map{|_| k,v = _.split("=");[k.to_sym, v]}.flatten]
      @options.merge!(queries)
    end
    parse_options(args)
    true
  end

  def try_path(args)
    return false unless args.first=~ %r(^([^/]+)/([^/]+)/([^/]+)$)
    @service = $1
    @section = $2
    @graph   = $3

    args.shift
    @options[:t] = args.shift if range_arg?(args.first)

    parse_options(args)
    true
  end

  def try_default(args)
    @service = args.shift
    @section = args.shift
    @graph   = args.shift

    @options[:t] = args.shift if range_arg?(args.first)

    parse_options(args)
    true
  end

  def set_ssl_options!
    @ssl_options = {}
    if @options.key?(:sslNoVerify) && RUBY_VERSION < "1.9.0"
      @ssl_options[:ssl_verify_mode] = OpenSSL::SSL::VERIFY_NONE
    end
    if @options.key?(:sslCaCert)
      @ssl_options[:ssl_ca_cert] = @options[:sslCaCert]
    end
  end

  def help(options = {})
    puts @opt_parse_obj.banner
    puts <<-MSG

    exsamples)
      gfspark http://your.gf.com/view_graph/your_service/your_section/your_graph?t=h
      gfspark your_service/your_section/your_graph h --url=http://your.gf.com/view_graph
      gfspark your_service your_section your_graph h --url=http://your.gf.com/view_graph

    MSG
    puts "  Options:"
    puts @opt_parse_obj.summarize
  end

  def parse_options(args)
    @opt_parse_obj.parse!(args)
    args
  end


  def detect_width_and_height!
    @stty_height, @stty_width = `stty size`.split.map(&:to_i)

    width = ((@stty_width - 12) / 2).floor
    @options[:width] ||= width
    @width = @options[:width].to_i
    height = @options[:height].to_i
    @height = height.zero? ? 10 : height
  end

  def opt_parser
    OptionParser.new{|opts|
      opts.banner = '<url|path|service_name> [section_name] [graph_name]'
      opts.on("--url=VALUE", "Your GrowthForecast URL"){|v| @options[:url] = v}
      opts.on('-u=USER',  '--user=USER'){|v| @options[:username] = v }
      opts.on('-p=PASS',  '--pass=PASS'){|v| @options[:password] = v }
      opts.on("-t=VALUE", "Range of Graph"){|v| @options[:t] = v}
      opts.on("--from=VALUE", "Start date of graph.(2011/12/08 12:10:00) required if t=c or sc"){|v| @options[:from] = v}
      opts.on("--to=VALUE", "End date of graph.(2011/12/08 12:10:00) required if t=c or sc"){|v| @options[:to] = v}
      opts.on("-h=VALUE", "--height=VALUE", "graph height.(default 10"){|v| @options[:height] = v}
      opts.on("-w=VALUE", "--width=VALUE", "graph width.(default is deteced from $COLUMNS"){|v| @options[:width] = v}
      opts.on("-c=VALUE", "--color=VALUE", "Color of graph bar"){|v| @options[:color] = v}
      opts.on("--sslnoverify", "don't verify SSL"){|v| @options[:sslNoVerify] = true}
      opts.on("--sslcacert=v", "SSL CA CERT"){|v| @options[:sslCaCert] = v}
      opts.on("--debug", "debug print"){@debug= true }
    }
  end
end
