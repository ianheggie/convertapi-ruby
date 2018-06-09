require 'stringio'

RSpec.describe ConvertApi do
  it 'has configuration defaults' do
    expect(described_class.config.api_base_uri).not_to be_nil
    expect(described_class.config.connect_timeout).not_to be_nil
    expect(described_class.config.conversion_timeout).not_to be_nil
  end

  describe '.configure' do
    let(:api_secret) { 'test_secret' }
    let(:conversion_timeout) { 20 }

    it 'configures' do
      described_class.configure do |config|
        config.api_secret = api_secret
        config.conversion_timeout = conversion_timeout
      end

      expect(described_class.config.api_secret).to eq(api_secret)
      expect(described_class.config.conversion_timeout).to eq(conversion_timeout)
    end
  end

  describe '.client' do
    subject { described_class.client }

    it { is_expected.to be_instance_of(ConvertApi::Client) }
  end

  describe '.convert' do
    subject { described_class.convert(resource, to_format, from_format, params) }

    let(:from_format) { 'docx' }
    let(:to_format) { 'pdf' }
    let(:resource) { 'examples/files/test.docx' }
    let(:params) { {} }

    shared_examples 'successful conversion' do
      it 'returns result' do
        expect(subject).to be_instance_of(ConvertApi::Result)
        expect(subject.conversion_cost).to be_instance_of(Integer)
        # p subject.save_files('/tmp')
      end
    end

    it_behaves_like 'successful conversion'

    context 'when from format not specified' do
      let(:from_format) { nil }

      it_behaves_like 'successful conversion'
    end

    context 'with web resource' do
      let(:from_format) { 'web' }
      let(:resource) { 'http://convertapi.com' }

      it_behaves_like 'successful conversion'
    end

    context 'with io source' do
      let(:from_format) { 'txt' }
      let(:resource) { ConvertApi::UploadIO.new(io, 'test.txt') }
      let(:io) { StringIO.new('Hello world') }

      it_behaves_like 'successful conversion'
    end

    context 'when secret is not set' do
      before { ConvertApi.config.api_secret = nil }

      it 'raises error' do
        expect { subject }.to raise_error(ConvertApi::SecretError, /not configured/)
      end
    end

    context 'with invalid secret' do
      before { ConvertApi.config.api_secret = 'invalid' }

      it 'raises error' do
        expect { subject }.to raise_error(ConvertApi::ClientError, /bad secret/)
      end
    end
  end
end
