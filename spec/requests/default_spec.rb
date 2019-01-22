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

  describe 'GET /stream', type: :request do
    before do
      DRate::Actions::DRate.settings.path = path
      stub_const('Default::StreamController::DELAY', delay)
      DRate::Streams.instance.reset
      allow(DRate::Streams.instance)
        .to receive(:include?)
        .and_return(false, true, false)
      original_register = DRate::Streams.instance.method(:register)
      allow(DRate::Streams.instance).to receive(:register) do |stream|
        original_register[stream]
        DRate::Streams.instance.broadcast(rate)
      end
      get '/stream'
    end

    subject { response }

    let(:delay) { 0.1 }
    let(:rate) { DRate::Actions::DRate.show }
    let(:path) { "#{Rails.root}/spec/fixtures/data/drate" }

    describe 'headers' do
      subject { response.headers }

      it { is_expected.to include('Content-Type') }

      describe '`Content-Type` value' do
        subject { response.headers['Content-Type'] }

        it { is_expected.to be == 'text/event-stream' }
      end
    end

    describe 'output stream buffer' do
      subject { response.stream.instance_variable_get(:@buf) }

      context 'when nothing happens' do
        let(:ping) { Default::StreamController::PING_MESSAGE }

        it 'should have ping' do
          expect(subject.first).to include(ping)
        end
      end

      context 'when content of the file with dollar\'s rate changes' do
        it 'should have the rate' do
          expect(subject.first).to include(rate)
        end
      end
    end
  end
end
