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
require 'term/ansicolor'

module Gfspark
  def self.main(argv)
    status = true

    app = nil
    begin
      app = Gfspark::App.new(argv)
      app.execute

    rescue => e
      puts e
      puts e.backtrace.join("\n")
      status = false
    end

    exit(status)
  end
end

require File.dirname(__FILE__) + '/gfspark/config'
require File.dirname(__FILE__) + '/gfspark/connection'
require File.dirname(__FILE__) + '/gfspark/graph'
require File.dirname(__FILE__) + '/gfspark/app'
