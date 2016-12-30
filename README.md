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
outputs = client.models.predict(Clariner::Model::GENERAL, 'https://samples.clarifai.com/metro-north.jpg')
````
