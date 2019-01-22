# frozen_string_literal: true

require 'rails_helper'

require "#{Rails.root}/lib/drate/notifier"

RSpec.describe DRate::Notifier do
  describe 'the class' do
    subject { described_class }

    it 'should not have public `.new`' do
      expect(subject.public_methods).not_to include(:new)
    end

    it { is_expected.to respond_to(:instance) }
  end

  describe '.instance' do
    subject(:result) { described_class.instance }

    describe 'result' do
      subject { result }

      it { is_expected.to be_an_instance_of(described_class) }

      it { is_expected.to be_a(Singleton) }

      it { is_expected.to respond_to(:on_close_write, :forget) }
    end
  end

  describe '#on_close_write' do
    let(:path) { "#{Rails.root}/spec/fixtures/drate" }
    let(:label) { :drate }
    let(:delay) { 0.1 }

    context 'when the file has been closed after it was opened for writing' do
      before { `touch #{path}` }

      after do
        described_class.instance.forget(label)
        `rm -f #{path}`
      end

      it 'should yield the label' do
        expect do |b|
          described_class.instance.on_close_write(path, label, &b)
          `echo 1 > #{path}`
          sleep(delay)
        end.to yield_with_args label
      end
    end
  end

  describe '#forget' do
    subject { described_class.instance.forget(label) }

    before { `touch #{path}` }

    after { `rm -f #{path}` }

    let(:path) { "#{Rails.root}/spec/fixtures/drate" }
    let(:label) { :drate }
    let(:delay) { 0.1 }

    it 'should remove subscription' do
      expect do |b|
        described_class.instance.on_close_write(path, label, &b)
        subject
        `echo 1 > #{path}`
        sleep(delay)
      end.not_to yield_control
    end
  end
end
