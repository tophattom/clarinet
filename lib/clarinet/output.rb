module Clarinet
  class Output

    attr_reader :id
    attr_reader :input
    attr_reader :concepts
    attr_reader :colors

    def self.from_api_data(api_data)
      id = api_data['id']
      input = api_data['input']['data']['image']['url']

      concepts = []
      colors = []

      if api_data['data']['concepts']
        concepts = api_data['data']['concepts'].map do |concept|
          Clarinet::Concept.new concept['id'], concept['name'], concept['api_id'], concept['value']
        end
      end

      if api_data['data']['colors']
        colors = api_data['data']['colors'].map do |color|
          Clarinet::Color.new color['raw_hex'], color['value']
        end
      end

      Clarinet::Output.new id, input, concepts, colors
    end

    def initialize(id, input, concepts, colors)
      @id = id
      @input = input
      @concepts = concepts
      @colors = colors
    end

  end
end
