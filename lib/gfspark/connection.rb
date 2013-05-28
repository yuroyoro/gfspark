module Gfspark::Connection
  @ssl_options = {}

  def connection(host, port)
    env = ENV['http_proxy'] || ENV['HTTP_PROXY']
    if env
      uri = URI(env)
      proxy_host, proxy_port = uri.host, uri.port
      Net::HTTP::Proxy(proxy_host, proxy_port).new(host, port)
    else
      Net::HTTP.new(host, port)
    end
  end

  def fetch_json(url, options = {}, params = {})
    response = send_request(url, {},options, params, :get)
    raise response.code unless response_success?(response)
    json = JSON.parse(response.body)

    if @debug
      puts '-' * 80
      puts url
      pp json
      puts '-' * 80
    end

    json
  end

  def send_request(url, json = {}, options = {}, params = {}, method = :post)
    url = "#{url}"
    uri = URI.parse(url)

    if @debug
      puts '-' * 80
      puts url
      pp json
      puts '-' * 80
    end

    https = connection(uri.host, uri.port)
    https.use_ssl = true
    https.verify_mode = @ssl_options[:ssl_verify_mode] || OpenSSL::SSL::VERIFY_NONE

    store = OpenSSL::X509::Store.new
    if @ssl_options[:ssl_ca_cert].present?
      if File.directory? @ssl_options[:ssl_ca_cert]
        store.add_path @ssl_options[:ssl_ca_cert]
      else
        store.add_file @ssl_options[:ssl_ca_cert]
      end
      http.cert_store = store
    else
      store.set_default_paths
    end
    https.cert_store = store

    https.set_debug_output $stderr if @debug && https.respond_to?(:set_debug_output)

    https.start{|http|

      path = "#{uri.path}"
      path += "?" + params.map{|k,v| "#{k}=#{v}"}.join("&") unless params.empty?

      request = case method
        when :post then Net::HTTP::Post.new(path)
        when :put  then Net::HTTP::Put.new(path)
        when :get  then Net::HTTP::Get.new(path)
        else raise "unknown method #{method}"
      end

      request.set_content_type("application/json")
      request.body = json.to_json if json.present?

      response = http.request(request)
      if @debug
        puts "#{response.code}: #{response.msg}"
        puts response.body
      end

      response
    }
  end

  def response_success?(response)
    code = response.code.to_i
    code >= 200 && code < 300
  end
end
