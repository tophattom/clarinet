# frozen_string_literal: true

require 'uri'

module Clarinet
  class Utils

    URL_REGEX = /\A#{URI::regexp(%w(http https))}\z/

    def self.check_response_status(status)
      status_code = status['code']

      return if status_code == Clarinet::Status::SUCCESS

      error_class = Clarinet::ApiError
      error_class = Clarinet::InvalidAuthTokenError if status_code == Clarinet::Status::INVALID_AUTH_TOKEN
      error_class = Clarinet::ApiKeyNotFoundError if status_code == Clarinet::Status::API_KEY_NOT_FOUND
      error_class = Clarinet::BadRequestFormatError if status_code == Clarinet::Status::BAD_REQUEST_FORMAT
      error_class = Clarinet::InvalidRequestError if status_code == Clarinet::Status::INVALID_REQUEST
      error_class = Clarinet::ImageDecodingError if status_code == Clarinet::Status::IMAGE_DECODING_FAILED

      new_error = error_class.new status['description']
      new_error.code = status_code
      new_error.description = status['description']
      new_error.details = status['details']
      raise new_error
    end

    def self.format_model(model_data)
      formatted = {
        id: model_data[:id]
      }

      formatted[:name] = model_data[:name] if model_data.key? :name

      output_info = {}
      if model_data.key? :concepts_mutually_exclusive
        output_info[:output_config] = output_info[:output_config] || {}
        output_info[:output_config][:concepts_mutually_exclusive] = model_data[:concepts_mutually_exclusive]
      end

      if model_data.key? :closed_environment
        output_info[:output_config] = output_info[:output_config] || {}
        output_info[:output_config][:closed_environment] = model_data[:closed_environment]
      end

      if model_data.key? :concepts
        output_info[:data] = {
          concepts: model_data[:concepts].map { |c| format_concept(c) }
        }
      end

      formatted[:output_info] = output_info
      formatted
    end

    def self.format_concept(concept_data)
      return { id: concept_data } if concept_data.is_a? String
      concept_data
    end

    def self.format_input(input_data, include_image = true)
      input_data = { url: input_data } if input_data.is_a? String

      formatted = {
        id: input_data[:id],
        data: {}
      }

      formatted[:data][:concepts] = input_data.concepts if input_data.key? :concepts
      formatted[:data][:metadata] = input_data.metadata if input_data.key? :metadata
      formatted[:data][:geo] = { geo_point: input_data.geo } if input_data.key? :geo

      if include_image
        formatted[:data][:image] = {
          url: input_data[:url],
          base64: input_data[:base64],
          crop: input_data[:crop],
          allow_duplicate_url: input_data.fetch(:allow_duplicate_url, false)
        }
      end

      formatted
    end

    def self.format_media_predict(input_data, type = :image)
      if input_data.is_a? String
        input_data = { base64: input_data }
        input_data = { url: input_data } if input_data =~ URL_REGEX
      end

      data = {}
      data[type] = input_data
      { data: data }
    end

  end
end
