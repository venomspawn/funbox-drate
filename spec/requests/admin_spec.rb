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

  describe 'POST /admin', type: :request do
    before do
      DRate::Actions::ARate.settings.path = arate_path
      DRate::Actions::DRate.settings.path = drate_path
      post '/admin', params: params
    end

    subject { response }

    let(:arate_path) { "#{Rails.root}/spec/fixtures/data/arate" }
    let(:drate_path) { "#{Rails.root}/spec/fixtures/data/drate" }
    let(:params) { { rate: rate, date: date, time: time } }
    let(:rate) { '123,456' }
    let(:date) { Time.now.strftime('%Y-%m-%d') }
    let(:time) { Time.now.strftime('%H:%M:%S') }

    it { is_expected.to redirect_to admin_url }

    it 'should invoke `DRate::Actions::ARate#save' do
      expect(DRate::Actions::ARate).to receive(:save)
      post '/admin', params: params
    end

    context 'when request parameters are invalid' do
      let(:params) { {} }

      it 'should notice about it on the redirected page' do
        follow_redirect!
        expect(response.body)
          .to include(Admin::RateController::NOTICE_INVALID_PARAMS)
      end
    end

    context 'when date value in request parameters is invalid' do
      let(:date) { '2019-13-32' }

      it 'should notice about it on the redirected page' do
        follow_redirect!
        expect(response.body)
          .to include(Admin::RateController::NOTICE_INVALID_DATETIME)
      end
    end

    context 'when time value in request parameters is invalid' do
      let(:time) { '25:61:61' }

      it 'should notice about it on the redirected page' do
        follow_redirect!
        expect(response.body)
          .to include(Admin::RateController::NOTICE_INVALID_DATETIME)
      end
    end

    context 'when a general error appears' do
      before { allow(DRate::Actions::ARate).to receive(:save).and_raise }

      it 'should notice about it on the redirected page' do
        post '/admin', params: params
        follow_redirect!
        expect(response.body).to include(Admin::RateController::NOTICE_ERROR)
      end
    end
  end
end
