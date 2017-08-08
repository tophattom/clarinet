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

    attr_reader :raw_data

    attr_reader :id
    attr_reader :name
    attr_reader :created_at
    attr_reader :app_id
    attr_reader :output_info
    attr_reader :model_version

    def initialize(app, raw_data)
      @app = app

      @raw_data = raw_data

      @id = raw_data['id'] || raw_data[:id]
      @name = raw_data['name'] || raw_data[:name]
      @created_at = raw_data['created_at'] || raw_data[:created_at]
      @app_id = raw_data['app_id'] || raw_data[:app_id]
      @output_info = raw_data['output_info'] || raw_data[:output_info]

      @model_version = raw_data['model_version'] || raw_data[:model_version]
    end

    def predict(inputs)
      inputs = [inputs] unless inputs.is_a? Array

      inputs = inputs.map do |input|
        {
          data: {
            image: {
              url: input
            }
          }
        }
      end

      results = inputs.each_slice(MAX_INPUT_COUNT).map do |inputs_slice|
        @app.client.outputs id, inputs_slice
      end

      results.flatten
    end

    def versions(options = { page: 1, per_page: 20 })
      @app.client.model_versions @id, options
    end

    def delete_concepts(concepts)
      concepts = [concepts] unless concepts.is_a? Array
      update 'remove', { concepts: concepts }
    end

    def merge_concepts(concepts)
      concepts = [concepts] unless concepts.is_a? Array
      update 'merge', { concepts: concepts }
    end

    def overwrite_concepts(concepts)
      concepts = [concepts] unless concepts.is_a? Array
      update 'merge', { concepts: concepts }
    end

    def train
      response_data = @app.client.model_train @id
      Clarinet::Model.new @app, response_data['model']
    end

    private

      def update(action, obj)
        model_data = obj.merge id: @id
        data = {
          models: [Clarinet::Utils.format_model(model_data)]
        }

        response_data = @app.client.models_update data
        Clarinet::Model.new @app, response_data['models'].first
      end

  end
end
