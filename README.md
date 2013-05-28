# gfspark

Growth Forecast on Terminal.

gfspark is CLI graph viewer for Growth Forecast.

## Installation

Add this line to your application's Gemfile:

    gem 'gfspark'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gfspark

## Usage

    usage: gfspark <url|path|service_name> [section_name] [graph_name]

      Examples:
        gfspark http://your.gf.com/view_graph/your_service/your_section/your_graph?t=h
        gfspark your_service/your_section/your_graph h --url=http://your.gf.com/view_graph
        gfspark your_service your_section your_graph h --url=http://your.gf.com/view_graph

      Options:
            --url=VALUE                  Your GrowthForecast URL
        -u, --user=USER
        -p, --pass=PASS
        -t=VALUE                         Range of Graph
            --from=VALUE                 Start date of graph.(2011/12/08 12:10:00) required if t=c or sc
            --to=VALUE                   End date of graph.(2011/12/08 12:10:00) required if t=c or sc
        -h, --height=VALUE               graph height.(default 10
        -w, --width=VALUE                graph width.(default is deteced from $COLUMNS
        -c, --color=VALUE                Color of graph bar
            --sslnoverify                don't verify SSL
            --sslcacert=v                SSL CA CERT
            --debug                      debug print

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
