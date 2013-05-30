# gfspark

Growth Forecast on Terminal.

gfspark is a CLI graph viewer for Growth Forecast.

## Installation

Add this line to your application's Gemfile:

    gem 'gfspark'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gfspark

## ScreenShots

<img src='https://github.com/yuroyoro/gfspark/raw/master/images/gfspark_screenshot1.png' width='600'/>
<img src='https://github.com/yuroyoro/gfspark/raw/master/images/gfspark_screenshot2.png' width='600'/>

## Usage

    gfspark : Growth Forecast on Terminal

    usage: gfspark <url|path|service_name> [section_name] [graph_name]

      Examples:
        gfspark http://your.gf.com/view_graph/your_service/your_section/your_graph?t=h
        gfspark your_service/your_section/your_graph h --url=http://your.gf.com/view_graph
        gfspark your_service your_section your_graph h --url=http://your.gf.com/view_graph

      Options:
            --url=VALUE                  Your GrowthForecast URL
        -u, --user=USER
        -p, --pass=PASS
        -t, --type=VALUE                 Range of Graph
            --gmode=VALUE                graph mode: gauge or subtract (default is gauge)
            --from=VALUE                 Start date of graph (2011/12/08 12:10:00) required if t=c or sc
            --to=VALUE                   End date of graph (2011/12/08 12:10:00) required if t=c or sc
        -h, --height=VALUE               graph height (default 10
        -w, --width=VALUE                graph width (default is deteced from $COLUMNS)
        -c, --color=VALUE                Color of graph bar (black/red/green/yellow/blue/magenta/cyan/white)
        -x, --x-axis-label=VALUE         Show x axis labels (hide/show/simple: default is show)
        -n, --non-fullwidth-font         Show bar symbol as fullwidth
            --sslnoverify                don't verify SSL
            --sslcacert=v                SSL CA CERT
            --debug                      debug print

        -t option detail:
            y : Year (1day avg)
            m : Month (2hour avg)
            w : Week (30min avg)
           3d : 3 Days (5min avg)
          s3d : 3 Days (5min avg)
            d : Day (5min avg)
           sd : Day (1min avg)
           8h : 8 Hours (5min avg)
          s8h : 8 Hours (1min avg)
           4h : 4 Hours (5min avg)
          s4h : 4 Hours (1min avg)
            h : Hour (5min avg)
           sh : Hour (1min avg)
            n : Half Day (5min avg)
           sn : Half Day (1min avg)
            c : Custom (5min avg)
           sc : Custom (1min avg)

gfspark does not supports "COMPLEX GRAPH".
if graph output is broken, try `--non-fullwidth-font` option.
For example, if your Terminal font is "Rickty", then it'll be fix graph output problem.

## Configuration

gfspark load default settings from `.gfspark` file.
This configuration file is searched from current dirctory to pararents, or your home directory(~/.gfspark).

.gfspark is YAML file.  It's contents is like bellow

    url: http://your.growthforecast.com/
    color: red
    username: "your basic auth username"
    password: "your basic auth password"
    non_fullwidth_font: true

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
