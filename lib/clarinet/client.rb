# frozen_string_literal: true

require 'httparty'

module Clarinet
  class Client
    include HTTParty

    base_uri 'https://api.clarifai.com/v2'

    def initialize(api_key)
      @headers = {
        'Authorization' => "Key #{api_key}",
        'Content-Type' => 'application/json'
      }
    end

    def models(options = {})
      self.class.get '/models', headers: @headers, query: options
    end

    def model(id)
      self.class.get "/models/#{id}", headers: @headers
    end

    def models_search(query)
      body = { model_query: query }
      self.class.post '/models/searches', headers: @headers, body: body.to_json
    end

    def outputs(model_id, inputs)
      body = { inputs: inputs }
      self.class.post "/models/#{model_id}/outputs", headers: @headers, body: body.to_json
    end

  end
end
