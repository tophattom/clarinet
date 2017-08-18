module Clarinet
  module Error
    class ApiError < StandardError
      attr_accessor :code
      attr_accessor :description
      attr_accessor :details
    end

    class InvalidAuthTokenError < ApiError

    end

    class ApiKeyNotFoundError < ApiError

    end

    class BadRequestFormatError < ApiError

    end

    class InvalidRequestError < ApiError

    end

    class ImageDecodingError < ApiError

    end
  end
end
