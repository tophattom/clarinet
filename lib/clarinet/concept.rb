module Clarinet
  class Concept

    attr_reader :id
    attr_reader :name
    attr_reader :app_id
    attr_reader :value

    def initialize(id, name, app_id, value)
      @id = id
      @name = name
      @app_id = app_id
      @value = value
    end

  end
end
