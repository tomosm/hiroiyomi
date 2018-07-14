# frozen_string_literal: true

require 'spec_helper'
require 'net/http'
require 'tempfile'

RSpec.describe Hiroiyomi do
  it 'has a version number' do
    expect(Hiroiyomi::VERSION).to eq '0.1.5'
  end

  describe '#read' do
    # context 'resource of the url is unconnectable' do
    #   # let(:url) { 'https://www.goole.com' }
    #   # let(:url) { 'https://yahoo.co.jp' }
    #   let(:url) { 'http://www.lim.global/' }
    #
    #   it {
    #     actual = Hiroiyomi.read(url, filter: %w[h1 h2 h3 a img])
    #     # p "actual:", actual
    #     # p actual.select { |e| e.name == 'h1' }.length
    #     # puts actual.select { |e| e.name == 'h2' }.length
    #     # # puts actual.select { |e| e.name == 'h2' }.map(&:to_s)
    #     # p actual.select { |e| e.name == 'h3' }.length
    #     # p actual.select { |e| e.name == 'a' }.length
    #     # p actual.select { |e| e.name == 'img' }.length
    #     # expect(true).to be false
    #     # expect { Hiroiyomi.read(url, filter: %w[h1 h2 h3 a img]) }.to raise_error(SocketError)
    #   }
    # end

    context 'url is nil' do
      it { expect { Hiroiyomi.read(nil) }.to raise_error(URI::InvalidURIError) }
    end

    context 'url is empty' do
      it { expect { Hiroiyomi.read('') }.to raise_error(URI::BadURIError) }
    end

    context 'url is present' do
      include_context 'tempfile_shared_context'

      context 'resource of the url is present' do
        context 'simple' do
          let(:url) { 'https://present.hiroiyomi' }
          before do
            tempfile.write('
<!doctype html>
<html>
<head>
  <script type=\'text/javascript\'>/*<![CDATA[*/!function(e,t,r){function <...> ])/*]]>*/</script>
</head>
<body>
<h1>hoge</h1>
<div>
  <h1>foo<a href="/a1">a1</a>baz</h1>
  <img
      src="/img1.png"
      draggable="false">
  <br/>
  <img src="/img2.jpg"/>bar<a href="/a2">a2</a>::after
</div><!-- #page -->
<meta http-equiv="imagetoolbar" content="no"><!-- disable image toolbar (if any) -->
<!--[if lte IE 8]>
<link rel=\'stylesheet\' id=\'jetpack-carousel-ie8fix-css\'  href=\'https://pozlife.net/wp-content/plugins/jetpack/modules/carousel/jetpack-carousel-ie8fix.css?ver=20121024\' type=\'text/css\' media=\'all\' />
<![endif]-->
</html>
                         ')

            tempfile.rewind
          end

          it 'is empty without filter' do
            expect(Hiroiyomi.read(url)).to eq []
          end

          context 'when filter is specified' do
            let(:filter) { %w[h1 a img] }

            it 'should get only filtered elements' do
              actual = Hiroiyomi.read(url, filter: filter)

              h1_elements = actual.select { |e| e.name == 'h1' }
              expect(h1_elements.length).to eq 2
              expect(h1_elements.map(&:to_s).sort.join(' ')).to eq '<h1>foo<a href="/a1">a1</a>baz</h1> <h1>hoge</h1>'
              expect(h1_elements.map(&:inner_html).sort.join(' ')).to eq 'foo<a href="/a1">a1</a>baz hoge'

              a_elements = actual.select { |e| e.name == 'a' }
              expect(a_elements.length).to eq 2
              expect(a_elements.map(&:to_s).sort.join(' ')).to eq '<a href="/a1">a1</a> <a href="/a2">a2</a>'
              expect(a_elements.map(&:inner_html).sort.join(' ')).to eq 'a1 a2'

              img_elements = actual.select { |e| e.name == 'img' }
              expect(img_elements.length).to eq 2
              expect(img_elements.map(&:to_s).sort.join(' ')).to eq '<img src="/img1.png" draggable="false"></img> <img src="/img2.jpg"></img>'
              expect(img_elements.map(&:inner_html).sort.join).to eq ''
            end

            context 'when filter is not deep' do
              it 'should get only filtered elements' do
                actual = Hiroiyomi.read(url, filter: filter, is_deep: false)

                h1_elements = actual.select { |e| e.name == 'h1' }
                expect(h1_elements.length).to eq 2
                expect(h1_elements.map(&:to_s).sort.join(' ')).to eq '<h1>foo<a href="/a1">a1</a>baz</h1> <h1>hoge</h1>'
                expect(h1_elements.map(&:inner_html).sort.join(' ')).to eq 'foo<a href="/a1">a1</a>baz hoge'

                a_elements = actual.select { |e| e.name == 'a' }
                expect(a_elements.length).to eq 1
                expect(a_elements.map(&:to_s).sort.join(' ')).to eq '<a href="/a2">a2</a>'
                expect(a_elements.map(&:inner_html).sort.join(' ')).to eq 'a2'

                img_elements = actual.select { |e| e.name == 'img' }
                expect(img_elements.length).to eq 2
                expect(img_elements.map(&:to_s).sort.join(' ')).to eq '<img src="/img1.png" draggable="false"></img> <img src="/img2.jpg"></img>'
                expect(img_elements.map(&:inner_html).sort.join).to eq ''
              end
            end
          end
        end

        context 'element names are big letters' do
          let(:url) { 'https://present.hiroiyomi' }
          before do
            tempfile.write('
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="https://www.google.com/">here</A>.
</BODY></HTML>
                         ')
            tempfile.rewind
          end
          let(:filter) { %w[h1 a img] }

          it 'gets case-insensitive elements and element names are the same as original ones' do
            actual = Hiroiyomi.read(url, filter: filter)

            h1_elements = actual.select { |e| e.name == 'H1' }
            expect(h1_elements.length).to eq 1
          end
        end

        context 'complex' do
          let(:url) { 'https://present.hiroiyomi' }
          before do
            tempfile.write('
<html lang="en">
<body id="page1">
<div class="bg">
  <header>
    <div class="main">
      <div class="page-head">
        <div class="head-text">
          </h1>
          <h3b style="padding-left: 10px; letter-spacing: 1px;">
            <a href="/pt">a</a>
            | <a href="/es">a</a></h3b>
          <div class="clear"></div>
        </div>
      </div>
    </div>
  </header>
  <section id="content">
    <div class="main">
    </div>
  </section>
</div>
  <!--==============================footer=================================-->
</body>
</html>
                         ')
            tempfile.rewind
          end
          let(:filter) { %w[h1 a img] }

          it 'gets case-insensitive elements and element names are the same as original ones' do
            actual = Hiroiyomi.read(url, filter: filter)

            h1_elements = actual.select { |e| e.name == 'h1' }
            expect(h1_elements.length).to eq 0

            h1_elements = actual.select { |e| e.name == 'a' }
            expect(h1_elements.length).to eq 2

            h1_elements = actual.select { |e| e.name == 'img' }
            expect(h1_elements.length).to eq 0
          end
        end
      end

      context 'resource is actual data' do
        let(:url) { 'https://actual.hiroiyomi' }
        before do
          dummy_data = "#{Hiroiyomi.root}/spec/support/data/actual_data.html"
          tempfile.write(File.new(dummy_data).read)
          tempfile.rewind
        end

        let(:filter) { %w[h1 h2 h3 a link] }
        it 'should get only filtered elements' do
          actual = Hiroiyomi.read(url, filter: filter)

          expect(actual.select { |e| e.name == 'h1' }.length).to eq 2
          expect(actual.select { |e| e.name == 'h2' }.length).to eq 25
          expect(actual.select { |e| e.name == 'h3' }.length).to eq 5
          expect(actual.select { |e| e.name == 'a' }.length).to eq 222
          expect(actual.select { |e| e.name == 'link' }.length).to eq 35
        end
      end

      context 'resource is wwww.google.com' do
        let(:url) { 'https://google.com.hiroiyomi' }
        before do
          dummy_data = "#{Hiroiyomi.root}/spec/support/data/google.com.html"
          tempfile.write(File.new(dummy_data).read)
          tempfile.rewind
        end

        let(:filter) { %w[h1 h2 h3 a link] }
        it 'should get only filtered elements' do
          actual = Hiroiyomi.read(url, filter: filter)

          expect(actual.select { |e| e.name == 'h1' }.length).to eq 0
          expect(actual.select { |e| e.name == 'h2' }.length).to eq 0
          expect(actual.select { |e| e.name == 'h3' }.length).to eq 0
          expect(actual.select { |e| e.name == 'a' }.length).to eq 21
          expect(actual.select { |e| e.name == 'link' }.length).to eq 1
        end
      end

      context 'resource is yahoo.co.jp' do
        let(:url) { 'https://yahoo.co.jp.hiroiyomi' }
        before do
          dummy_data = "#{Hiroiyomi.root}/spec/support/data/yahoo.co.jp.html"
          tempfile.write(File.new(dummy_data).read)
          tempfile.rewind
        end

        let(:filter) { %w[h1 h2 h3 a link] }
        it 'should get only filtered elements' do
          actual = Hiroiyomi.read(url, filter: filter)

          expect(actual.select { |e| e.name == 'h1' }.length).to eq 0
          expect(actual.select { |e| e.name == 'h2' }.length).to eq 0
          expect(actual.select { |e| e.name == 'h3' }.length).to eq 0
          expect(actual.select { |e| e.name == 'a' }.length).to eq 59
          expect(actual.select { |e| e.name == 'link' }.length).to eq 3
        end
      end

      context 'resource of the url is empty' do
        let(:resource_empty_url) { 'https://empty.hiroiyomi' }
        it { expect(Hiroiyomi.read(resource_empty_url)).to eq [] }
      end
    end

    context 'resource of the url is unconnectable' do
      let(:unconnectable_url) { 'https://unconnectable.hiroiyomi' }
      it { expect { Hiroiyomi.read(unconnectable_url) }.to raise_error(SocketError) }
    end
  end
end
