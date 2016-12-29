# Clarinet

Ruby client for Clarifai API v2

## Requirements

* httparty

## Install

## Usage

````ruby
# Your client ID and secret
client_id = '...'
client_secret = '...'

# Initialize
client = Clarinet::App.new client_id, client_secret

# Get predictions for image with URL
# predict also accepts an array of URLs to get predictions for
# multiple images at the same time
outputs = client.predict('https://samples.clarifai.com/metro-north.jpg')

# Extract concepts from the response
outputs.each do |output|
  puts output.concepts
end
````
