describe Clarinet::Model do

  before :each do
    app = Clarinet::App.new 'fake_api_key'
    @model = app.models.init_model Clarinet::Model::GENERAL
  end

  describe '#predict' do
    it 'should call /outputs endpoint with correct payload given single url' do
      req_stub = stub_request(:post, "https://api.clarifai.com/v2/models/#{Clarinet::Model::GENERAL}/outputs")
        .with(body: {
          inputs: [
            {
              data: {
                image: {
                  url: 'https://samples.clarifai.com/metro-north.jpg'
                }
              }
            }
          ]
        })
        .to_return(fixture_file('model-predict-default'))

      @model.predict 'https://samples.clarifai.com/metro-north.jpg'

      expect(req_stub).to have_been_requested
    end

    it 'should call API endpoint with correct payload given multiple urls' do
      req_stub = stub_request(:post, "https://api.clarifai.com/v2/models/#{Clarinet::Model::GENERAL}/outputs")
        .with(body: {
          inputs: [
            {
              data: {
                image: {
                  url: 'https://samples.clarifai.com/metro-north.jpg'
                }
              }
            },
            {
              data: {
                image: {
                  url: 'https://samples.clarifai.com/metro-north-2.jpg'
                }
              }
            }
          ]
        })
        .to_return(fixture_file('model-predict-default'))

      @model.predict ['https://samples.clarifai.com/metro-north.jpg', 'https://samples.clarifai.com/metro-north-2.jpg']

      expect(req_stub).to have_been_requested
    end
  end

end
