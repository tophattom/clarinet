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

      @id = raw_data['id'] || raw_data[:id]
      @created_at = raw_data['created_at'] || raw_data[:created_at]
      @image_url = raw_data['data']['image_url'] || raw_data[:data][:image_url]

      @concepts = Clarinet::Concepts.new app, raw_data['data']['concepts']

      @score = raw_data['score'] || raw_data[:score]
      @metadata = raw_data['data']['metadata'] || raw_data[:data][:metadata]

      @raw_data = raw_data
    end

  end
end
