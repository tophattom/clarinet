require 'time'
require 'httparty'

module Clarinet
  class App
    include HTTParty

    base_uri 'https://api.clarifai.com'

    def initialize(client_id, client_secret)
      @credentials = {
        username: client_id,
        password: client_secret
      }
    end

    def predict(urls, model = Clarinet::Model::GENERAL)
      inputs = urls.map do |url|
        {
          data: {
            image: {
              url: url
            }
          }
        }
      end

      response = self.class.post(
        "/v2/models/#{model}/outputs",
        headers: auth_header.merge('Content-Type' => 'application/json'),
        body: { inputs: inputs }.to_json
      )

      data = response.parsed_response

      check_response_status data['status']

      response.parsed_response['outputs'].map do |output|
        Clarinet::Output.from_api_data output
      end
    end

    private

      def token
        retrieve_access_token unless @access_token
        retrieve_access_token if @access_token_expires_at < Time.now

        @access_token
      end

      def retrieve_access_token
        response = self.class.post(
          '/v2/token',
          basic_auth: @credentials,
          body: 'grant_type=client_credentials'
        )

        data = response.parsed_response

        check_response_status data['status']

        @access_token = data['access_token']
        @access_token_expires_at = Time.now + data['expires_in']
      end

      def auth_header
        { 'Authorization' => "Bearer #{token}" }
      end

      def check_response_status(status)
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
