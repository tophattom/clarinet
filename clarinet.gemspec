# frozen_string_literal: true

require_relative 'lib/clarinet/version'

Gem::Specification.new do |s|
  s.name = 'clarinet'
  s.version = Clarinet::VERSION
  s.summary = 'Clarifai API client'
  s.description = 'Simple client to interface with the Clarifai API v2'
  s.authors = ['Jaakko Rinta-Filppula']
  s.email = 'jaakko.rf@gmail.com'
  s.homepage = 'https://github.com/tophattom/clarinet'
  s.license = 'ISC'

  s.files = `git ls-files`.split("\n")

  s.add_dependency 'httparty', ['~> 0.14']
  s.add_dependency 'addressable', ['~> 2.5']
end
