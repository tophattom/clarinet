# frozen_string_literal: true

module Clarinet
  class Concepts
    extend Forwardable

    delegate [:[], :each, :map, :find, :select, :reject] => :@concepts

    def initialize(app, raw_data = [])
      @app = app
      @raw_data = raw_data

      @concepts = raw_data.map do |concept_data|
        Clarinet::Concept.new concept_data
      end
    end

    def create(concepts)
      concepts = [concepts] unless concepts.is_a? Array
      concepts = concepts.map { |concept| format_concept(concept) }

      data = @app.client.concepts.create concepts
      Clarinet::Concepts.new @app, data[:concepts]
    end

    def list(options = { page: 1, per_page: 20 })
      data = @app.client.concepts options
      Clarinet::Concepts.new @app, data[:concepts]
    end

    def get(id)
      data = @app.client.concept id
      Clarinet::Concept.new data[:concept]
    end

    def search(name, language = nil)
      query = {
        name: name,
        language: language
      }

      data = @app.client.concepts_search query
      Clarinet::Concepts.new @app, data[:concepts]
    end

  end
end
