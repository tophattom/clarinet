# frozen_string_literal: true

require 'time'
require 'httparty'

module Clarinet
  class App

    attr_reader :models

    def initialize(client_id, client_secret)
      @credentials = {
        username: client_id,
        password: client_secret
      }

      @models = Clarinet::Models.new self
    end

    def auth_header
      { 'Authorization' => "Bearer #{token}" }
    end

    private

      def token
        retrieve_access_token unless @access_token
        retrieve_access_token if @access_token_expires_at < Time.now

        @access_token
      end

      def retrieve_access_token
        url = "https://api.clarifai.com/v2/token"

        response = HTTParty.post(
          url,
          basic_auth: @credentials,
          body: 'grant_type=client_credentials'
        )

        data = response.parsed_response

        Clarinet::Utils.check_response_status data['status']

        @access_token = data['access_token']
        @access_token_expires_at = Time.now + data['expires_in']
      end

  end
end
