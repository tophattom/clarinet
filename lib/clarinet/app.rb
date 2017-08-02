# frozen_string_literal: true

module Clarinet
  class App

    attr_reader :client
    attr_reader :models

    def initialize(api_key)
      @client = Clarinet::Client.new api_key

      @models = Clarinet::Models.new self
    end

  end
end
