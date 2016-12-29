module Clarinet
  class ApiError < StandardError

  end

  class InvalidAuthTokenError < Clarinet::ApiError

  end

  class BadRequestFormatError < Clarinet::ApiError

  end
end
