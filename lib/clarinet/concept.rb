module Clarinet
  class Concept

    attr_reader :id
    attr_reader :name
    attr_reader :app_id
    attr_reader :value
    attr_reader :created_at
    attr_reader :raw_data

    def initialize(raw_data = {})
      @raw_data = raw_data

      @id = raw_data[:id]
      @name = raw_data[:name]
      @created_at = raw_data[:created_at]
      @app_id = raw_data[:app_id]
      @value = raw_data[:value]
    end

  end
end
