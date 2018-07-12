# frozen_string_literal: true

require 'spec_helper'
require 'net/http'
require 'tempfile'

RSpec.describe Hiroiyomi do
  it 'has a version number' do
    expect(Hiroiyomi::VERSION).to eq '0.1.0'
  end

  describe '#read' do
    context 'url is nil' do
      it { expect { Hiroiyomi.read(nil) }.to raise_error(URI::InvalidURIError) }
    end

    context 'url is empty' do
      it { expect { Hiroiyomi.read('') }.to raise_error(URI::BadURIError) }
    end

    context 'url is present' do
      include_context 'tempfile_shared_context'

      context 'resource of the url is present' do
        let(:url) { 'https://present.Hiroiyomi' }
        before do
          tempfile.write('<html><head><script>/*<![CDATA[*/!function(e,t,r){function <...> ])/*]]>*/</script></head><body><h1>hoge</h1><div>...</div><div><h1>foo</h1><br/><img src="/img.jpg"/>bar<a href="/a"></a></div></body></html>')
          tempfile.open
        end
        it { expect(Hiroiyomi.read(url)).to eq [] }

        context 'when filter is specified' do
          let(:filter) { %w[h1 a] }
          it do
            actual = Hiroiyomi.read(url, filter: filter)
            expect(actual.length).to eq 3
            expect(actual.select { |e| e.name == 'h1' }.map(&:content).sort).to eq %w[foo hoge]
            expect(actual.select { |e| e.name == 'a' }.map(&:attributes).flatten.map(&:to_s).sort).to eq %w[href="/a"]
          end
        end
      end

      context 'resource of the url is empty' do
        let(:resource_empty_url) { 'https://empty.Hiroiyomi' }
        it { expect(Hiroiyomi.read(resource_empty_url)).to eq [] }
      end
    end

    context 'resource of the url is unconnectable' do
      let(:unconnectable_url) { 'https://unconnectable.Hiroiyomi' }
      it { expect { Hiroiyomi.read(unconnectable_url) }.to raise_error(SocketError) }
    end
  end
end
