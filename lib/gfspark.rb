require "gfspark/version"
# -*- coding: utf-8 -*-

if RUBY_VERSION < '1.9.0'
  $KCODE = "UTF8"
else
  Encoding.default_external = Encoding.find('UTF-8')
end

require 'pp'
require 'rubygems'
require 'uri'
require 'open-uri'
require "net/http"
require "net/https"
require "uri"
require 'fileutils'
require 'json'
require 'optparse'
require 'yaml'
require 'term/ansicolor'

module Gfspark
  def self.main(argv)
    status = true

    app = nil
    begin
      app = Gfspark::App.new(argv)
      if app.valid
        status = app.execute
      else
        app.help
        return false
      end
    rescue => e
      puts e
      if app && app.debug
        puts e.backtrace.join("\n")
        pp app.options
      end
      status = false
    end

    exit(status)
  end
end

require File.dirname(__FILE__) + '/gfspark/config'
require File.dirname(__FILE__) + '/gfspark/connection'
require File.dirname(__FILE__) + '/gfspark/graph'
require File.dirname(__FILE__) + '/gfspark/app'
