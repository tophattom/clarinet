# frozen_string_literal: true

module Clarinet
  class Utils

    def self.check_response_status(status)
      status_code = status['code']

      return if status_code == Clarinet::Status::SUCCESS

      error_class = Clarinet::ApiError
      error_class = Clarinet::InvalidAuthTokenError if status_code == Clarinet::Status::INVALID_AUTH_TOKEN
      error_class = Clarinet::BadRequestFormatError if status_code == Clarinet::Status::BAD_REQUEST_FORMAT
      error_class = Clarinet::ImageDecodingError if status_code == Clarinet::Status::IMAGE_DECODING_FAILED

      raise error_class, code: status['code'], description: status['description']
    end

  end
end
