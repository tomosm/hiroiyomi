# frozen_string_literal: true

require 'spec_helper'
require 'net/http'
require 'tempfile'

RSpec.describe Hiroiyomi do
  it 'has a version number' do
    expect(Hiroiyomi::VERSION).to eq '0.1.0'
  end

  describe '#parse' do
    context 'url is nil' do
      it { expect { Hiroiyomi.parse(nil) }.to raise_error(URI::InvalidURIError) }
    end

    context 'url is empty' do
      it { expect { Hiroiyomi.parse('') }.to raise_error(URI::BadURIError) }
    end

    context 'url is present' do
      include_context 'tempfile_shared_context'

      context 'resource of the url is present' do
        let(:url) { 'https://present.Hiroiyomi' }
        before do
          tempfile.write('<html><body><h1>hoge</h1><div>...</div><div><h1>foo</h1><br/><img src="/img.jpg"/>bar<a href="/a"></a></div></body></html>')
          tempfile.open
        end

        it do
          actual = Hiroiyomi.parse(url)
          expect(actual.elements.length).to eq 9
          expect(actual.select { |e| e.name == 'html' }.length).to eq 1
          expect(actual.select { |e| e.name == 'body' }.length).to eq 1
          expect(actual.select { |e| e.name == 'h1' }.map(&:content).sort).to eq %w[foo hoge]
          expect(actual.select { |e| e.name == 'div' }.map(&:content).sort).to eq %w[... bar]
          expect(actual.select { |e| e.name == 'br' }.length).to eq 1
          expect(actual.select { |e| e.name == 'img' }.map { |e| e.attributes.map { |a| "#{a.name}=#{a.value}" } }.flatten).to eq %w[src=/img.jpg]
          expect(actual.select { |e| e.name == 'a' }.map { |e| e.attributes.map { |a| "#{a.name}=#{a.value}" } }.flatten).to eq %w[href=/a]
        end

        context 'when filter is specified' do
          let(:filter) do
            document         = Hiroiyomi::Html::Document.new
            document.element = Hiroiyomi::Html::Element.new('h1')
            document.element = Hiroiyomi::Html::Element.new('img')
            document.element = Hiroiyomi::Html::Element.new('a')
            document
          end
          it do
            actual = Hiroiyomi.parse(url, filter: filter)
            expect(actual.elements.length).to eq 4
            expect(actual.select { |e| e.name == 'html' }.length).to eq 0
            expect(actual.select { |e| e.name == 'body' }.length).to eq 0
            expect(actual.select { |e| e.name == 'h1' }.map(&:content).sort).to eq %w[foo hoge]
            expect(actual.select { |e| e.name == 'div' }.length).to eq 0
            expect(actual.select { |e| e.name == 'br' }.length).to eq 0
            expect(actual.select { |e| e.name == 'img' }.map { |e| e.attributes.map { |a| "#{a.name}=#{a.value}" } }.flatten).to eq %w[src=/img.jpg]
            expect(actual.select { |e| e.name == 'a' }.map { |e| e.attributes.map { |a| "#{a.name}=#{a.value}" } }.flatten).to eq %w[href=/a]
          end
        end
      end

      context 'resource of the url is empty' do
        let(:resource_empty_url) { 'https://empty.Hiroiyomi' }
        it { expect(Hiroiyomi.parse(resource_empty_url)).to be_a Hiroiyomi::Html::Document }
      end
    end

    context 'resource of the url is unconnectable' do
      let(:unconnectable_url) { 'https://unconnectable.Hiroiyomi' }
      it { expect { Hiroiyomi.parse(unconnectable_url) }.to raise_error(SocketError) }
    end
  end
end
