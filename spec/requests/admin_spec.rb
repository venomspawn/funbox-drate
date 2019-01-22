# frozen_string_literal: true

RSpec.describe 'Administrative access API' do
  describe 'GET /admin', type: :request do
    before do
      DRate::Actions::ARate.settings.path = path
      get '/admin'
    end

    subject { response }

    let(:path) { "#{Rails.root}/spec/fixtures/data/arate" }

    it { is_expected.to have_http_status(:ok) }

    describe 'body' do
      subject { response.body }

      it 'should include dollar\'s rate' do
        expect(subject).to include(IO.read(path))
      end

      it 'should include date till the rate is active' do
        expect(subject).to include(File.mtime(path).strftime('%Y-%m-%d'))
      end

      it 'should include time till the rate is active' do
        expect(subject).to include(File.mtime(path).strftime('%H:%M:%S'))
      end
    end
  end
end
