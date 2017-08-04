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
      inputs = inputs.map { |input| format_input(input) }

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

    private

      def format_input(input_data, include_image = true)
        input_data = { url: input_data } if input_data.is_a? String

        formatted = {
          id: input_data.fetch(:id, nil),
          data: {}
        }

        formatted[:data][:concepts] = input_data.concepts if input_data.key? :concepts
        formatted[:data][:metadata] = input_data.metadata if input_data.key? :metadata
        formatted[:data][:geo] = { geo_point: input_data.geo } if input_data.key? :geo

        if include_image
          formatted[:data][:image] = {
            url: input_data.fetch(:url, nil),
            base64: input_data.fetch(:base64, nil),
            crop: input_data.fetch(:crop, nil),
            allow_duplicate_url: input_data.fetch(:allow_duplicate_url, false)
          }
        end

        formatted
      end

  end
end
