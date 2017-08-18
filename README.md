Clarinet [![Build Status](https://travis-ci.org/tophattom/clarinet.svg?branch=master)](https://travis-ci.org/tophattom/clarinet)
===

Ruby client for [Clarifai](https://clarifai.com) API v2.

Clarinet matches Clarifai's official JavaScript SDK almost 1:1.
Method names are mostly the same expect in `snake_case` as opposed
to `camelCase` in the JS library.

## Dependencies

* `addressable`
* `httparty`

## Install

## Usage

```ruby
# Your client ID and secret
api_key = '...'

# Initialize
client = Clarinet::App.new api_key

# Get predictions for image with URL.
# Response keys are symbolized.
outputs = client.models.predict(Clarinet::Model::GENERAL, 'https://samples.clarifai.com/metro-north.jpg')
```
