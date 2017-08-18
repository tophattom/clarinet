# frozen_string_literal: true

module Clarinet
  class Inputs
    extend Forwardable

    # @!method []
    #   @see Array#[]
    #   @return [Clarinet::Model]
    # @!method each
    #   @see Array#each
    # @!method map
    #   @see Array#map
    # @!method find
    #   @see Array#find
    # @!method select
    #   @see Array#select
    # @!method select
    #   @see Array#select
    delegate [:[], :each, :map, :find, :select, :reject] => :@inputs

    # @!visibility private
    def initialize(app, raw_data = [])
      @app = app

      @raw_data = raw_data

      @inputs = raw_data.map do |input_data|
        Clarinet::Input.new app, input_data
      end
    end

    # Adds an input or multiple inputs
    # @return [Clarinet::Inputs] Instance of Inputs
    def create(inputs)
      inputs = [inputs] unless inputs.is_a? Array
      inputs = inputs.map { |input| Clarinet::Utils.format_input(input) }

      data = @app.client.inputs_create inputs
      Clarinet::Inputs.new data[:inputs]
    end

    # Delete an input or a list of inputs by id
    # @return [Hash] API response
    def delete(id)
      @app.client.input_delete id if id.is_a? String
      @app.client.inputs_delete id if id.is_a? Array
    end

    # Delete all inputs
    # @return [Hash] API response
    def delete_all
      @app.client.inputs_delete_all
    end

    # Get all inputs in app
    # @param options [Hash] Listing options
    # @option options [Int] :page (1) The page number
    # @option options [Int] :per_page (20) Number of models to return per page
    # @return [Clarinet::Inputs] Inputs instance
    def list(options = { page: 1, per_page: 20 })
      data = @app.client.inputs options
      Clarinet::Inputs.new @app, data[:inputs]
    end

    # Get input by id
    # @param id [String] The input id
    # @return [Clarinet::Input] Input instance
    def get(id)
      data = @app.client.input id
      Clarinet::Input.new @app, data[:input]
    end

    # Get inputs status (number of uploaded, in process or failed inputs)
    # @return [Hash] API response
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
        Clarinet::Inputs.new @app, response_data[:inputs]
      end

  end
end
