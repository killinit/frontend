RSpec.shared_examples_for 'a cms resource' do
  let(:url) { 'https://example.com' }

  describe '#find' do
    subject(:repository) { described_class.new }

    let(:id) { 'beginners-guide-to-managing-your-money' }
    let(:headers) { {} }

    before do
      allow(Core::Registry::Connection).to receive(:[]).with(:cms) do
        Core::ConnectionFactory::Http.build(url)
      end

      stub_request(
        :get,
        "https://example.com/#{I18n.locale}/#{resource_name}/#{id}.json"
      ).to_return(status: status, body: body, headers: headers)
    end

    context 'when the type exists' do
      let(:body) { File.read('spec/fixtures/cms/%s.json' % id) }
      let(:status) { 200 }

      it 'returns a hash of attributes' do
        expect(repository.find(id)).to be_a(Hash)
        expect(repository.find(id)['slug']).to eq(id)
      end

      it 'returns the meta description' do
        expect(repository.find(id)['description']).to eq('How to set up a budget, keep on top of your debts and start to save regularly')
      end
    end

    context 'when the type is non-existent' do
      let(:body) { nil }
      let(:status) { 404 }

      it 'returns nil' do
        expect(repository.find(id)).to be_nil
      end
    end

    context 'when there is a proxy authentication error' do
      let(:body) { nil }
      let(:status) { 407 }

      it 'raises an RequestError' do
        expect { repository.find(id) }.to raise_error(Core::Repository::Base::RequestError)
      end
    end

    context 'when there is an error' do
      let(:body) { nil }
      let(:status) { 500 }

      it 'raises an RequestError' do
        expect { repository.find(id) }.to raise_error(Core::Repository::Base::RequestError)
      end
    end
  end
end
