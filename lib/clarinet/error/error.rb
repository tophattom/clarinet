module Clarinet
  module Error
    class ApiError < StandardError
      attr_accessor :code
      attr_accessor :description
      attr_accessor :details
    end

    class InvalidAuthTokenError < Clarinet::ApiError

    end

    class ApiKeyNotFoundError < Clarinet::ApiError

    end

    class BadRequestFormatError < Clarinet::ApiError

    end

    class InvalidRequestError < Clarinet::ApiError

    end

    class ImageDecodingError < Clarinet::ApiError

    end
  end
end
