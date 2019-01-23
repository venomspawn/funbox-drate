# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DRate::Actions::DRate do
  describe 'the module' do
    subject { described_class }

    it { is_expected.to respond_to(:configure, :settings, :fetch, :show) }
  end

  describe '.settings' do
    subject(:result) { described_class.settings }

    describe 'result' do
      subject { result }

      it { is_expected.to respond_to(:path, :path=) }
    end
  end

  describe '.configure' do
    it 'should yield settings' do
      expect { |b| described_class.configure(&b) }
        .to yield_with_args described_class.settings
    end
  end

  describe '.fetch' do
    subject(:result) { described_class.fetch }

    describe 'result' do
      subject { result }

      context 'when no error appears' do
        before { stub_request(:get, /cbr/).to_return(body: body) }

        let(:body) { %(<Valute ID="R01235"><Value>#{value}</Value></Valute>) }
        let(:value) { '123.456' }

        it { is_expected.to be_a(String) }

        it 'should be the dollar\'s rate' do
          expect(subject).to be == value
        end
      end

      context 'when response body is not supported' do
        before { stub_request(:get, /cbr/).to_return(body: body) }

        let(:body) { '<Valute ID="R01235"><Valu3></Valu3></Valute>' }

        it { is_expected.to be_a(String) }

        it 'should be default value' do
          expect(subject).to be == described_class::Fetch::DEFAULT
        end
      end

      context 'when an error raises' do
        before { allow(HTTP).to receive(:get).and_raise }

        it { is_expected.to be_a(String) }

        it 'should be default value' do
          expect(subject).to be == described_class::Fetch::DEFAULT
        end
      end
    end
  end

  describe '.show' do
    subject(:result) { described_class.show }

    describe 'result' do
      subject { result }

      context 'when no error appears' do
        before { described_class.settings.path = path }

        let(:path) { __FILE__ }

        it { is_expected.to be_a(String) }

        it 'should be the content of the file by settings path' do
          expect(subject).to be == IO.read(path)
        end
      end

      context 'when an error appears' do
        before { described_class.settings.path = nil }

        it { is_expected.to be_a(String) }
        it { is_expected.to be_empty }
      end
    end
  end
end
