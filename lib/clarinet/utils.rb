# frozen_string_literal: true

module Clarinet
  class Utils

    def self.check_response_status(status)
      status_code = status['code']

      return if status_code == Clarinet::Status::SUCCESS

      error_class = Clarinet::ApiError
      error_class = Clarinet::InvalidAuthTokenError if status_code == Clarinet::Status::INVALID_AUTH_TOKEN
      error_class = Clarinet::ApiKeyNotFoundError if status_code == Clarinet::Status::API_KEY_NOT_FOUND
      error_class = Clarinet::BadRequestFormatError if status_code == Clarinet::Status::BAD_REQUEST_FORMAT
      error_class = Clarinet::ImageDecodingError if status_code == Clarinet::Status::IMAGE_DECODING_FAILED

      new_error = error_class.new status['description']
      new_error.code = status_code
      new_error.description = status['description']
      new_error.details = status['details']
      raise new_error
    end

  end
end
