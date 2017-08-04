# frozen_string_literal: true

require 'httparty'

module Clarinet
  class Client
    include HTTParty

    base_uri 'https://api.clarifai.com/v2'
    headers 'Content-Type' => 'application/json'

    def initialize(api_key)
      @auth_headers = {
        'Authorization' => "Key #{api_key}"
      }
    end

    def models(options = {})
      with_response_parsing do
        self.class.get '/models', headers: @auth_headers, query: options
      end
    end

    def model(id)
      with_response_parsing do
        self.class.get "/models/#{id}", headers: @auth_headers
      end
    end

    def models_search(query)
      body = { model_query: query }

      with_response_parsing do
        self.class.post '/models/searches', headers: @auth_headers, body: body.to_json
      end
    end

    def outputs(model_id, inputs)
      body = { inputs: inputs }

      with_response_parsing do
        self.class.post "/models/#{model_id}/outputs", headers: @auth_headers, body: body.to_json
      end
    end

    def concepts(options = {})
      with_response_parsing do
        self.class.get '/concepts', headers: @auth_headers, query: options
      end
    end

    def concept(id)
      with_response_parsing do
        self.class.get "/concepts/#{id}", headers: @auth_headers
      end
    end

    def concepts_search(query)
      body = { concept_query: query }

      with_response_parsing do
        self.class.post '/concepts/searches', headers: @auth_headers, body: body.to_json
      end
    end

    private

      def with_response_parsing(&block)
        response = yield
        data = response.parsed_response
        Clarinet::Utils.check_response_status data['status']
        data
      end

  end
end
