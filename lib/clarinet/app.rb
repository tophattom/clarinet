# frozen_string_literal: true

module Clarinet
  class App

    # @!visibility private
    attr_reader :client

    # @return [Clarinet::Concepts]
    attr_reader :concepts

    # @return [Clarinet::Inputs]
    attr_reader :inputs

    # @return [Clarinet::Models]
    attr_reader :models

    # @param api_key [String] Clarifai API key
    def initialize(api_key)
      @client = Clarinet::Client.new api_key

      @concepts = Clarinet::Concepts.new self
      @inputs = Clarinet::Inputs.new self
      @models = Clarinet::Models.new self
    end

  end
end
