# frozen_string_literal: true

module Clarinet
  class App

    attr_reader :client
    attr_reader :concepts
    attr_reader :models

    def initialize(api_key)
      @client = Clarinet::Client.new api_key

      @concepts = Clarinet::Concepts.new self
      @models = Clarinet::Models.new self
    end

  end
end
