module ConvertApi
  class Result
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def conversion_cost
      response['ConversionCost']
    end

    def file
      files.first
    end

    def files
      @files ||= response['Files'].map{ |file_info| ResultFile.new(file_info) }
    end

    def urls
      files.map{|o| o.url}
    end

    def save_files(path)
      if ConvertApi::USE_THREADS
        threads = files.map do |file|
          Thread.new { file.save(path) }
        end

        threads.map do |thread|
          thread.value
        end
      else
        files.map do |file|
          file.save(path)
        end
      end
    end
  end
end
