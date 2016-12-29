module Clarinet
  class Output

    attr_reader :id
    attr_reader :input
    attr_reader :concepts

    def self.from_api_data(api_data)
      id = api_data['id']
      input = api_data['input']['data']['image']['url']

      concepts = api_data['data']['concepts'].map do |concept|
        Clarinet::Concept.new concept['id'], concept['name'], concept['api_id'], concept['value']
      end

      Clarinet::Output.new id, input, concepts
    end

    def initialize(id, input, concepts)
      @id = id
      @input = input
      @concepts = concepts
    end

  end
end
