# frozen_string_literal: true

module Clarinet
  class Input

    attr_reader :id
    attr_reader :created_at
    attr_reader :image_url
    attr_reader :concepts
    attr_reader :score
    attr_reader :metadata
    attr_reader :raw_data

    def initialize(app, raw_data)
      @app = app

      @id = raw_data[:id]
      @created_at = raw_data[:created_at]
      @image_url = raw_data[:data][:image_url]

      @concepts = Clarinet::Concepts.new app, raw_data[:data][:concepts]

      @score = raw_data[:score]
      @metadata = raw_data[:data][:metadata]

      @raw_data = raw_data
    end

    def merge_concepts(concepts, metadata = nil)
      update 'merge', concepts: concepts, metadata: metadata
    end

    def delete_concepts(concepts, metadata = nil)
      update 'remove', concepts: concepts, metadata: metadata
    end

    def overwrite_concepts(concepts, metadata = nil)
      update 'overwrite', concepts: concepts, metadata: metadata
    end

    private

      def update(action, concepts: [], metadata: nil)
        input_data = {}
        input_data[:concepts] = concepts unless concepts.empty?
        input_data[:metadata] = metadata unless metadata.nil?

        data = {
          action: action,
          inputs: [
            {
              id: id,
              data: input_data
            }
          ]
        }

        response_data = @app.client.inputs_update data
        Clarinet::Input.new response_data[:input]
      end

  end
end
