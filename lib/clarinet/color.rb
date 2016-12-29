module Clarinet
  class Color

    attr_reader :raw_hex
    attr_reader :value

    def initialize(raw_hex, value)
      @raw_hex = raw_hex
      @value = value
    end

  end
end
