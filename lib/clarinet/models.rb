# frozen_string_literal: true

require 'httparty'

module Clarinet
  class Models
    include Enumerable

    attr_reader :raw_data

    def initialize(app, raw_data = [])
      @app = app
      @raw_data = raw_data

      @models = raw_data.map do |model_data|
        Clarinet::Model.new app, model_data
      end
    end

    def init_model(model)
      model_data = {}

      model_data['id'] = model if model.is_a? String
      model_data = model if model.is_a? Hash
      model_data = model.raw_data if model.is_a? Clarinet::Model

      return Clarinet::Model.new @app, model_data if model_data['id']

      # TODO: search for a model in the API if no id is given
    end

    def predict(model, inputs)
      init_model(model).predict(inputs)
    end

    def list(options = { page: 1, per_page: 20 })
      url = 'https://api.clarifai.com/v2/models'

      response = HTTParty.get(
        url,
        headers: @app.auth_header,
        query: options
      )

      data = response.parsed_response

      Clarinet::Utils.check_response_status data['status']

      Clarinet::Models.new @app, data['models']
    end

    # Enumerable mixin
    def each(&block)
      @models.each(&block)
    end

  end
end
