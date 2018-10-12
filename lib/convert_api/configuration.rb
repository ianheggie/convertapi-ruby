module ConvertApi
  class Configuration
    attr_accessor :api_secret
    attr_accessor :base_uri
    attr_accessor :connect_timeout
    attr_accessor :read_timeout
    attr_accessor :conversion_timeout
    attr_accessor :conversion_timeout_delta
    attr_accessor :upload_timeout
    attr_accessor :download_timeout

    def initialize
      @base_uri = URI('https://v2.convertapi.com/')
      @connect_timeout = 15
      @read_timeout = 120
      @conversion_timeout = 180
      @conversion_timeout_delta = 20
      @upload_timeout = 600
      @download_timeout = 600
    end
  end
end
