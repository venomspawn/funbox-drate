# frozen_string_literal: true

RSpec.describe 'Default access API' do
  describe 'GET /', type: :request do
    before do
      DRate::Actions::DRate.settings.path = path
      get '/'
    end

    subject { response }

    let(:path) { "#{Rails.root}/spec/fixtures/data/drate" }

    it { is_expected.to have_http_status(:ok) }

    describe 'body' do
      subject { response.body }

      it 'should include dollar\'s rate' do
        expect(subject).to include(IO.read(path))
      end
    end
  end
end
