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

    def create(inputs)
      inputs = [inputs] unless inputs.is_a? Array
      inputs = inputs.map { |input| Clarinet::Utils.format_input(input) }

      data = @app.client.inputs_create inputs
      Clarinet::Inputs.new data['inputs']
    end

    def delete(id)
      @app.client.input_delete id if id.is_a? String
      @app.client.inputs_delete id if id.is_a? Array
    end

    def delete_all
      @app.client.inputs_delete_all
    end

    def list(options = { page: 1, per_page: 20 })
      data = @app.client.inputs options
      Clarinet::Inputs.new @app, data['inputs']
    end

    def get(id)
      data = @app.client.input id
      Clarinet::Input.new @app, data['input']
    end

    def status
      @app.client.inputs_status
    end

    def merge_concepts(inputs)
      update 'merge', inputs
    end

    def overwrite_concepts(inputs)
      update 'overwrite', inputs
    end

    def delete_concepts(inputs)
      update 'remove', inputs
    end

    private

      def update(action, inputs)
        inputs = [inputs] unless inputs.is_a? Array
        inputs = inputs.map { |input| Clarinet::Utils.format_input(input) }

        data = {
          action: action,
          inputs: inputs
        }

        response_data = @app.client.inputs_update data
        Clarinet::Inputs.new @app, response_data['inputs']
      end

  end
end
