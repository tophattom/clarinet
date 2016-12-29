require_relative 'lib/clarinet/version'

Gem::Specification.new do |s|
  s.name = 'clarinet'
  s.version = Clarinet::VERSION
  s.summary = 'Clarifai API client'
  s.description = 'Simple client to interface with the Clarifai API v2'
  s.authors = ['Jaakko Rinta-Filppula']
  s.files = Dir['{lib}/**/*.rb']

  s.add_dependency 'httparty', ['~> 0.14.0']
end
