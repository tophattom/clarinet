# frozen_string_literal: true

require 'httparty'

module Clarinet
  class Client
    include HTTParty

    base_uri 'https://api.clarifai.com/v2'
    headers 'Content-Type' => 'application/json'

    debug_output STDOUT

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

    def input_update(data)
      with_response_parsing do
        self.class.patch '/inputs', headers: @auth_headers, body: data.to_json
      end
    end

    def inputs(options = {})
      with_response_parsing do
        self.class.get '/inputs', headers: @auth_headers, query: options
      end
    end

    def inputs_create(inputs)
      body = { inputs: inputs }

      with_response_parsing do
        self.class.post '/inputs', headers: @auth_headers, body: body.to_json
      end
    end

    def input_delete(id)
      with_response_parsing do
        self.class.delete "/inputs/#{id}", headers: @auth_headers
      end
    end

    def inputs_delete(ids)
      body = { ids: ids }

      with_response_parsing do
        self.class.delete '/inputs', headers: @auth_headers, body: body.to_json
      end
    end

    def inputs_delete_all
      body = { delete_all: true }

      with_response_parsing do
        self.class.delete '/inputs', headers: @auth_headers, body: body.to_json
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
