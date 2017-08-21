# frozen_string_literal: true

module Clarinet
  class Models
    extend Forwardable

    # @!method []
    #   @see Array#[]
    #   @return [Clarinet::Model]
    # @!method each
    #   @see Array#each
    # @!method map
    #   @see Array#map
    # @!method find
    #   @see Array#find
    # @!method first
    #   @see Array#first
    # @!method last
    #   @see Array#last
    # @!method select
    #   @see Array#select
    # @!method select
    #   @see Array#select
    delegate [:[], :each, :map, :find, :first, :last, :select, :reject, :size] => :@models

    # @return [Hash] Raw API data used to construct this instance
    attr_reader :raw_data

    # @!visibility private
    def initialize(app, raw_data = [])
      @app = app
      @raw_data = raw_data

      @models = raw_data.map do |model_data|
        Clarinet::Model.new app, model_data
      end
    end

    # Returns a Model instance given model id or name. It will call search if name is given.
    # @param model [String, Hash, Clarinet::Model]
    #   If String, it is assumed to be model id. Otherwise, if Hash is given, it can have any of the following keys:
    # @option model [String] :id Model id
    # @option model [String] :name Model name
    # @option model [String] :version Model version
    # @option model [String] :type (nil) This can be "concept", "color", "embed", "facedetect", "cluster" or "blur"
    # @return [Clarinet::Model] Model instance corresponding to the given id
    #   or the first search result
    def init_model(model)
      model_data = {}

      model_data[:id] = model if model.is_a? String
      model_data = model if model.is_a? Hash
      model_data = model.raw_data if model.is_a? Clarinet::Model

      return Clarinet::Model.new @app, model_data if model_data[:id]

      search_results = search model_data[:name], model_data[:type]

      return search_results.find { |result| result.model_version.id == model_data[:version] }.first if model_data[:version]

      search_results.first
    end

    # Predict using a specific model
    # @param model (see #init_model)
    # @param inputs (see Clarinet::Model#predict)
    # @macro predict_inputs
    # @return [Hash] Data returned by the API with symbolized keys
    def predict(model, inputs)
      init_model(model).predict(inputs)
    end

    # Return all the models
    # @param options [Hash] Listing options
    # @option options [Int] :page (1) The page number
    # @option options [Int] :per_page (20) Number of models to return per page
    # @return [Clarinet::Models]
    def list(options = { page: 1, per_page: 20 })
      data = @app.client.models options
      Clarinet::Models.new @app, data[:models]
    end

    # Returns a model specified by ID
    # @param id [String] The model's id
    # @return [Clarinet::Model] Model instance
    def get(id)
      data = @app.client.model id
      Clarinet::Model.new @app, data[:model]
    end

    # Search for models by name or type
    # @param name [String] The model name
    # @param type [String] This can be "concept", "color", "embed", "facedetect", "cluster" or "blur"
    # @return [Clarinet::Models] Models instance
    def search(name, type = nil)
      query = {
        name: name,
        type: type
      }

      data = @app.client.models_search query
      Clarinet::Models.new @app, data[:models]
    end

  end
end
