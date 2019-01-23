# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DRate::Actions::ARate do
  describe 'the module' do
    subject { described_class }

    it { is_expected.to respond_to(:configure, :settings, :show, :save) }
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
    include described_class::Show::SpecHelper

    subject(:result) { described_class.show }

    describe 'result' do
      subject { result }

      context 'when no error appears' do
        before { described_class.settings.path = path }

        let(:path) { __FILE__ }

        it { is_expected.to match_json_schema(schema) }

        describe 'value of `rate` field' do
          subject { result[:rate] }

          it 'should be the content of the file by settings path' do
            expect(subject).to be == IO.read(path)
          end
        end

        describe 'value of `date` field' do
          subject { result[:date] }

          it 'should be modification date of the file by settings path' do
            expect(subject).to be == File.mtime(path).strftime('%Y-%m-%d')
          end
        end

        describe 'value of `time` field' do
          subject { result[:time] }

          it 'should be modification time of the file by settings path' do
            expect(subject).to be == File.mtime(path).strftime('%H:%M:%S')
          end
        end
      end

      context 'when an error appears' do
        before { described_class.settings.path = nil }

        it { is_expected.to match_json_schema(schema) }

        describe 'value of `rate` field' do
          subject { result[:rate] }

          it { is_expected.to be_empty }
        end

        describe 'value of `date` field' do
          subject { result[:date] }

          it { is_expected.to be_empty }
        end

        describe 'value of `time` field' do
          subject { result[:time] }

          it { is_expected.to be_empty }
        end
      end
    end
  end

  describe '.save' do
    before do
      DRate::Actions::ARate.settings.path = arate_path
      DRate::Actions::DRate.settings.path = drate_path
    end

    after do
      IO.write(arate_path, default_rate)
      IO.write(drate_path, default_rate)
    end

    subject { described_class.save(params.with_indifferent_access) }

    let(:arate_path) { "#{Rails.root}/spec/fixtures/data/arate" }
    let(:drate_path) { "#{Rails.root}/spec/fixtures/data/drate" }
    let(:default_rate) { '123,456' }
    let(:params) { { rate: rate, date: date, time: time } }
    let(:rate) { '456,123' }
    let(:date) { now.strftime('%Y-%m-%d') }
    let(:time) { now.strftime('%H:%M:%S') }
    let(:now) { Time.now }

    it 'should save rate into the files' do
      subject
      expect(IO.read(arate_path)).to be == rate
      expect(IO.read(drate_path)).to be == rate
    end

    it 'should save modification time of the files' do
      subject
      expect(File.mtime(arate_path)).to be_within(1).of(now)
      expect(File.mtime(drate_path)).to be_within(1).of(now)
    end

    context 'when parameters don\'t satisfy schema' do
      let(:params) { {} }

      it 'should raise JSON::Schema::ValidationError' do
        expect { subject }.to raise_error(JSON::Schema::ValidationError)
      end

      it 'shouldn\'t change content of the files' do
        expect { subject }
          .to raise_error(JSON::Schema::ValidationError)
          .and not_change { IO.read(arate_path) }
        expect { subject }
          .to raise_error(JSON::Schema::ValidationError)
          .and not_change { IO.read(drate_path) }
      end

      it 'shouldn\'t change modification time of the files' do
        expect { subject }
          .to raise_error(JSON::Schema::ValidationError)
          .and not_change { File.mtime(arate_path) }
        expect { subject }
          .to raise_error(JSON::Schema::ValidationError)
          .and not_change { File.mtime(drate_path) }
      end
    end

    context 'when date value is wrong' do
      let(:date) { '2019-13-32' }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError)
      end

      it 'shouldn\'t change content of the files' do
        expect { subject }
          .to raise_error(ArgumentError)
          .and not_change { IO.read(arate_path) }
        expect { subject }
          .to raise_error(ArgumentError)
          .and not_change { IO.read(drate_path) }
      end

      it 'shouldn\'t change modification time of the files' do
        expect { subject }
          .to raise_error(ArgumentError)
          .and not_change { File.mtime(arate_path) }
        expect { subject }
          .to raise_error(ArgumentError)
          .and not_change { File.mtime(drate_path) }
      end
    end

    context 'when time value is wrong' do
      let(:time) { '25:61:61' }

      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError)
      end

      it 'shouldn\'t change content of the files' do
        expect { subject }
          .to raise_error(ArgumentError)
          .and not_change { IO.read(arate_path) }
        expect { subject }
          .to raise_error(ArgumentError)
          .and not_change { IO.read(drate_path) }
      end

      it 'shouldn\'t change modification time of the files' do
        expect { subject }
          .to raise_error(ArgumentError)
          .and not_change { File.mtime(arate_path) }
        expect { subject }
          .to raise_error(ArgumentError)
          .and not_change { File.mtime(drate_path) }
      end
    end
  end
end
