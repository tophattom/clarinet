module Clarinet
  class ApiError < StandardError
    attr_reader :code
    attr_reader :description

    def initialize(opts)
      @code = opts[:code]
      @description = opts[:description]
    end
  end

  class InvalidAuthTokenError < Clarinet::ApiError

  end

  class BadRequestFormatError < Clarinet::ApiError

  end

  class ImageDecodingError < Clarinet::ApiError

  end
end
