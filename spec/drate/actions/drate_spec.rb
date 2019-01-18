# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DRate::Actions::DRate do
  describe 'the module' do
    subject { described_class }

    it { is_expected.to respond_to(:configure, :settings, :show) }
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
