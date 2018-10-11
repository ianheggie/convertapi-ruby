require 'net/https'
require 'uri'

module ConvertApi
  class ResultFile
    attr_reader :info

    def initialize(info)
      @info = info
    end

    def url
      info['Url']
    end

    def filename
      info['FileName']
    end

    def size
      info['FileSize']
    end

    def http(params = {})
      http = Net::HTTP.new(base_uri.host, base_uri.port)
      http.open_timeout = config.connect_timeout
      http.read_timeout = params[:read_timeout] || config.read_timeout
      http.use_ssl = base_uri.scheme == 'https'
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE if http.use_ssl && RUBY_VERSION == '1.8.7'
      # http.set_debug_output $stderr
      http
    end

    def save(path)
      path = File.join(path, filename) if File.directory?(path)

      request = Net::HTTP::Get.new(url, Client::DEFAULT_HEADERS)

      response = http({}).request(request)

      status = response.code.to_i

      if status != 200
        headers = { }
        response.each_header{|key,value| headers[key] = value }
        raise(
            ClientError,
            :status => status,
            :body => response.body,
            :headers => headers
        )
      end
      File.open(path, 'w') do |f|
        f.write response.body
      end

      path
    end

    private

    def config
      ConvertApi.config
    end

    def base_uri
      config.base_uri
    end

  end
end
