# frozen_string_literal: true

module Clarinet
  class Inputs
    extend Forwardable

    delegate [:[], :each, :map, :find, :select, :reject] => :@inputs

    def initialize(app, raw_data = [])
      @app = app

      @raw_data = raw_data

      @inputs = raw_data.map do |input_data|
        Clarinet::Input.new app, input_data
      end
    end

    def list(options = { page: 1, per_page: 20 })
      data = @app.client.inputs options
      Clarinet::Inputs.new @app, data['inputs']
    end

    def get(id)
      data = @app.client.input id
      Clarinet::Input.new @app, data['input']
    end

  end
end
