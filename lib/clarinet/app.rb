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
      status = data['status']

      raise Clarinet::BadRequestFormatError if status['code'] == Clarinet::Status::BAD_REQUEST_FORMAT
      raise Clarinet::ApiError unless status['code'] == Clarinet::Status::SUCCESS

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
        status = data['status']

        raise Clarinet::InvalidAuthTokenError if status['code'] == Clarinet::Status::INVALID_AUTH_TOKEN
        raise Clarinet::ApiError unless status['code'] == Clarinet::Status::SUCCESS

        @access_token = data['access_token']
        @access_token_expires_at = Time.now + data['expires_in']
      end

      def auth_header
        { 'Authorization' => "Bearer #{token}" }
      end

  end
end
