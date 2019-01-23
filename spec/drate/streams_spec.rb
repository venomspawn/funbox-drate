# frozen_string_literal: true

require 'rails_helper'

require "#{Rails.root}/lib/drate/streams"

RSpec.describe DRate::Streams do
  describe 'the class' do
    subject { described_class }

    it { is_expected.not_to respond_to(:new) }

    it { is_expected.to respond_to(:instance) }
  end

  describe '.instance' do
    subject(:result) { described_class.instance }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(Singleton) }

      it { is_expected.to be_an_instance_of(described_class) }

      messages = %i[include? register broadcast reset]
      it { is_expected.to respond_to(*messages) }
    end
  end

  describe '#include?' do
    subject(:result) { instance.include?(stream) }

    let(:instance) { described_class.instance }

    describe 'result' do
      subject { result }

      context 'when the stream is in the pool' do
        before { instance.register(stream) }

        after { instance.reset }

        let(:stream) { 'stream' }

        it { is_expected.to be_truthy }
      end

      context 'when the stream is not in the pool' do
        let(:stream) { 'stream' }

        it { is_expected.to be_falsey }
      end
    end
  end

  describe '#register' do
    after { instance.reset }

    subject { instance.register(stream) }

    let(:instance) { described_class.instance }
    let(:stream) { 'stream' }

    it 'should add the stream to the pool' do
      expect { subject }
        .to change { instance.include?(stream) }
        .from(false)
        .to(true)
    end
  end

  describe '#broadcast' do
    subject { instance.broadcast(data) }

    before { instance.register(stream) }

    after { instance.reset }

    let(:instance) { described_class.instance }
    let(:data) { 'data' }
    let(:stream) { double }

    it 'should call #write with data message' do
      allow(stream).to receive(:write)
      expect(stream).to receive(:write).with("data: #{data}\n\n")
      subject
    end

    context 'when the data is multilined' do
      let(:data) { [line1, line2].join("\n") }
      let(:line1) { 'line1' }
      let(:line2) { 'line2' }

      it 'should call #write with proper data message' do
        allow(stream).to receive(:write)
        expect(stream)
          .to receive(:write)
          .with("data: #{line1}\ndata: #{line2}\n\n")
        subject
      end
    end

    context 'when the stream raises an error with #write call' do
      before { allow(stream).to receive(:write).and_raise }

      it 'should ignore it' do
        expect { subject }.not_to raise_error
      end

      it 'should remove the stream from the pool' do
        expect { subject }
          .to change { instance.include?(stream) }
          .from(true)
          .to(false)
      end
    end
  end

  describe '#reset' do
    subject { instance.reset }

    before { instance.register(stream) }

    let(:instance) { described_class.instance }
    let(:stream) { 'stream' }

    it 'should remove all streams from the pool' do
      expect { subject }
        .to change { instance.include?(stream) }
        .from(true)
        .to(false)
    end
  end
end
