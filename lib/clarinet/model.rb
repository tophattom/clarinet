# frozen_string_literal: true

require 'httparty'

module Clarinet
  class Model

    GENERAL = 'aaa03c23b3724a16a56b629203edc62c'
    FOOD = 'bd367be194cf45149e75f01d59f77ba7'
    TRAVEL = 'eee28c313d69466f836ab83287a54ed9'
    NSFW = 'e9576d86d2004ed1a38ba0cf39ecb4b1'
    WEDDINGS = 'c386b7a870114f4a87477c0824499348'
    COLOR = 'eeed0b6733a644cea07cf4c60f87ebb7'

    MAX_INPUT_COUNT = 128

    # @return [Hash] Raw API data used to construct this instance
    attr_reader :raw_data

    # @return [String] Model id
    attr_reader :id

    # @return [String] Model name
    attr_reader :name

    # @return [String] Created at timestamp
    attr_reader :created_at

    # @return [String]
    attr_reader :app_id

    # @return [Hash]
    attr_reader :output_info

    # @return [String]
    attr_reader :model_version

    # @!visibility private
    def initialize(app, raw_data)
      @app = app

      @raw_data = raw_data

      @id = raw_data[:id]
      @name = raw_data[:name]
      @created_at = raw_data[:created_at]
      @app_id = raw_data[:app_id]
      @output_info = raw_data[:output_info]

      @model_version = raw_data[:model_version]
    end

    # Returns all the model's output info
    # @return [Clarinet::Model] Model instance with complete output_info data
    def get_output_info
      response_data = @app.client.model_output_info @id
      Clarinet::Model.new @app, response_data[:model]
    end

    # Returns model ouputs according to inputs
    # @param inputs [String, Hash, Array<String>, Array<Hash>] An array of objects/object/string pointing to
    #   an image resource. A string can either be a url or base64 image bytes. Object keys explained below:
    # @!macro predict_inputs
    #   @option inputs [Hash] :image Object with at least +:url+ or +:base64+ key as explained below:
    #     * +:url+ (String) A publicly accessibly
    #     * +:base64+ (String) Base64 string representing image bytes
    #     * +:crop+ (Array<Float>) An array containing the percent to be cropped from top, left, bottom and right
    # @return [Hash] API response
    def predict(inputs, config = {})
      video = config[:video] || false
      config.delete :video

      inputs = [inputs] unless inputs.is_a? Array
      inputs = inputs.map { |input| Clarinet::Utils.format_media_predict(input) }

      @app.client.outputs id, inputs, config
    end

    # Returns a list of versions of the model
    # @param options [Hash] Listing options
    # @option options [Int] :page (1) The page number
    # @option options [Int] :per_page (20) Number of models to return per page
    # @return [Hash] API response
    def versions(options = { page: 1, per_page: 20 })
      @app.client.model_versions @id, options
    end

    # Remove concepts from a model
    # @param concepts [Array<Hash>] List of concept hashes with id
    # @return [Clarinet::Model] Model instance
    def delete_concepts(concepts)
      concepts = [concepts] unless concepts.is_a? Array
      update 'remove', { concepts: concepts }
    end

    # Merge concepts to a model
    # @param (see #delete_concepts)
    # @return (see #delete_concepts)
    def merge_concepts(concepts)
      concepts = [concepts] unless concepts.is_a? Array
      update 'merge', { concepts: concepts }
    end

    # Overwrite concepts in a model
    # @param (see #delete_concepts)
    # @return (see #delete_concepts)
    def overwrite_concepts(concepts)
      concepts = [concepts] unless concepts.is_a? Array
      update 'merge', { concepts: concepts }
    end

    # Create a new model version
    # @note Training takes some time and the new version will not be immediately available.
    # @return [Clarinet::Model] Model instance
    def train
      response_data = @app.client.model_train @id
      Clarinet::Model.new @app, response_data[:model]
    end

    private

      def update(action, obj)
        model_data = obj.merge id: @id
        data = {
          models: [Clarinet::Utils.format_model(model_data)]
        }

        response_data = @app.client.models_update data
        Clarinet::Model.new @app, response_data[:models].first
      end

  end
end
