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

        @access_token = data['access_token'] if status['code'] == Clarinet::Status::SUCCESS
        @access_token_expires_at = Time.now + data['expires_in']
      end

      def auth_header
        { 'Authorization' => "Bearer #{token}" }
      end

  end
end
