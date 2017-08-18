describe Clarinet::App do
  describe '#initialize' do
    it 'returns App instance with correct attr_accessors' do
      app = Clarinet::App.new 'fake_api_key'

      expect(app.client).to be_instance_of(Clarinet::Client)
      expect(app.concepts).to be_instance_of(Clarinet::Concepts)
      expect(app.models).to be_instance_of(Clarinet::Models)
      expect(app.inputs).to be_instance_of(Clarinet::Inputs)
    end
  end
end
