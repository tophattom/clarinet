describe Clarinet::Models do

  before :each do
    app = Clarinet::App.new 'fake_api_key'
    @models = app.models
  end

  describe '#init_model' do
    it 'should return a model instance given model id' do
      model = @models.init_model Clarinet::Model::GENERAL
      expect(model).to be_instance_of(Clarinet::Model)
      expect(model.id).to eq(Clarinet::Model::GENERAL)
    end
  end

  describe '#search' do
    it 'should call search API and return Clarinet::Models instance' do
      model_name = 'general-v1.3'
      model_type = 'concept'

      req_stub = stub_request(:post, 'https://api.clarifai.com/v2/models/searches')
        .with(body: { model_query: { name: model_name, type: model_type } })
        .to_return(File.new("#{File.dirname(__FILE__)}/fixtures/search-general-concept.txt"))

      result = @models.search model_name, model_type

      expect(req_stub).to have_been_requested
    end

    it 'should return correct Clarinet::Models instance' do
      model_name = 'general-v1.3'
      model_type = 'concept'

      stub_request(:post, 'https://api.clarifai.com/v2/models/searches')
      .with(body: { model_query: { name: model_name, type: model_type } })
      .to_return(File.new("#{File.dirname(__FILE__)}/fixtures/search-general-concept.txt"))

      result = @models.search model_name, model_type

      expect(result).to be_instance_of(Clarinet::Models)
      expect(result.size).to eq(1)
    end
  end

  describe '#list' do
    it 'should return Clarinet::Models with all models' do
      req_stub = stub_request(:get, 'https://api.clarifai.com/v2/models')
        .with(query: { page: 1, per_page: 20 })
        .to_return(File.new("#{File.dirname(__FILE__)}/fixtures/models-list.txt"))

      result = @models.list

      expect(req_stub).to have_been_requested

      expect(result).to be_instance_of(Clarinet::Models)
      expect(result.size).to eq(15)
    end

    it 'should use pagination options in the API call' do
      req_stub = stub_request(:get, 'https://api.clarifai.com/v2/models')
        .with(query: { page: 2, per_page: 33 })
        .to_return(File.new("#{File.dirname(__FILE__)}/fixtures/models-list.txt"))

      @models.list page: 2, per_page: 33

      expect(req_stub).to have_been_requested
    end
  end

end