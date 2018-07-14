# frozen_string_literal: true

require 'spec_helper'
require 'net/http'
require 'tempfile'

RSpec.describe Hiroiyomi do
  it 'has a version number' do
    expect(Hiroiyomi::VERSION).to eq '0.1.3'
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
        let(:url) { 'https://present.hiroiyomi' }
        before do
          tempfile.write('
<!doctype html>
<!--[if !IE]>
<html class="no-js ie9" lang="ja"
      itemscope
      itemtype="http://schema.org/WebSite"
      prefix="og: http://ogp.me/ns#" > <![endif]-->
<!--[if gt IE 9]><!-->
<html class="no-js" lang="ja"
      itemscope
      itemtype="http://schema.org/WebSite"
      prefix="og: http://ogp.me/ns#" > <!--<![endif]-->
<head>
  <script type=\'text/javascript\'>/*<![CDATA[*/!function(e,t,r){function <...> ])/*]]>*/</script>
  <script type=\'text/javascript\'>window.NREUM||(NREUM={}),__nr_require=function(e,t,n){function r(n){if(!t[n]){var o=t[n]={exports:{}};e[n][0].call(o.exports,function(t){var o=e[n][1][t];return r(o||t)},o,o.exports)}return t[n].exports}if("function"==typeof __nr_require)return __nr_require;for(var o=0;o<n.length;o++)r(n[o]);return r}({1:[function(e,t,n){function r(){}function o(e,t,n){return function(){return i(e,[f.now()].concat(u(arguments)),t?null:this,n),t?void 0:this}}var i=e("handle"),a=e(2),u=e(3),c=e("ee").get("tracer"),f=e("loader"),s=NREUM;"undefined"==typeof window.newrelic&&(newrelic=s);var p=["setPageViewName","setCustomAttribute","setErrorHandler","finished","addToTrace","inlineHit","addRelease"],d="api-",l=d+"ixn-";a(p,function(e,t){s[t]=o(d+t,!0,"api")}),s.addPageAction=o(d+"addPageAction",!0),s.setCurrentRouteName=o(d+"routeName",!0),t.exports=newrelic,s.interaction=function(){return(new r).get()};var m=r.prototype={createTracer:function(e,t){var n={},r=this,o="function"==typeof t;return i(l+"tracer",[f.now(),e,n],r),function(){if(c.emit((o?"":"no-")+"fn-start",[f.now(),r,o],n),o)try{return t.apply(this,arguments)}catch(e){throw c.emit("fn-err",[arguments,this,e],n),e}finally{c.emit("fn-end",[f.now()],n)}}}};a("setName,setAttribute,save,ignore,onEnd,getContext,end,get".split(","),function(e,t){m[t]=o(l+t)}),newrelic.noticeError=function(e){"string"==typeof e&&(e=new Error(e)),i("err",[e,f.now()])}},{}],2:[function(e,t,n){function r(e,t){var n=[],r="",i=0;for(r in e)o.call(e,r)&&(n[i]=t(r,e[r]),i+=1);return n}var o=Object.prototype.hasOwnProperty;t.exports=r},{}],3:[function(e,t,n){function r(e,t,n){t||(t=0),"undefined"==typeof n&&(n=e?e.length:0);for(var r=-1,o=n-t||0,i=Array(o<0?0:o);++r<o;)i[r]=e[t+r];return i}t.exports=r},{}],4:[function(e,t,n){t.exports={exists:"undefined"!=typeof window.performance&&window.performance.timing&&"undefined"!=typeof window.performance.timing.navigationStart}},{}],ee:[function(e,t,n){function r(){}function o(e){function t(e){return e&&e instanceof r?e:e?c(e,u,i):i()}function n(n,r,o,i){if(!d.aborted||i){e&&e(n,r,o);for(var a=t(o),u=m(n),c=u.length,f=0;f<c;f++)u[f].apply(a,r);var p=s[y[n]];return p&&p.push([b,n,r,a]),a}}function l(e,t){v[e]=m(e).concat(t)}function m(e){return v[e]||[]}function w(e){return p[e]=p[e]||o(n)}function g(e,t){f(e,function(e,n){t=t||"feature",y[n]=t,t in s||(s[t]=[])})}var v={},y={},b={on:l,emit:n,get:w,listeners:m,context:t,buffer:g,abort:a,aborted:!1};return b}function i(){return new r}function a(){(s.api||s.feature)&&(d.aborted=!0,s=d.backlog={})}var u="nr@context",c=e("gos"),f=e(2),s={},p={},d=t.exports=o();d.backlog=s},{}],gos:[function(e,t,n){function r(e,t,n){if(o.call(e,t))return e[t];var r=n();if(Object.defineProperty&&Object.keys)try{return Object.defineProperty(e,t,{value:r,writable:!0,enumerable:!1}),r}catch(i){}return e[t]=r,r}var o=Object.prototype.hasOwnProperty;t.exports=r},{}],handle:[function(e,t,n){function r(e,t,n,r){o.buffer([e],r),o.emit(e,t,n)}var o=e("ee").get("handle");t.exports=r,r.ee=o},{}],id:[function(e,t,n){function r(e){var t=typeof e;return!e||"object"!==t&&"function"!==t?-1:e===window?0:a(e,i,function(){return o++})}var o=1,i="nr@id",a=e("gos");t.exports=r},{}],loader:[function(e,t,n){function r(){if(!x++){var e=h.info=NREUM.info,t=d.getElementsByTagName("script")[0];if(setTimeout(s.abort,3e4),!(e&&e.licenseKey&&e.applicationID&&t))return s.abort();f(y,function(t,n){e[t]||(e[t]=n)}),c("mark",["onload",a()+h.offset],null,"api");var n=d.createElement("script");n.src="https://"+e.agent,t.parentNode.insertBefore(n,t)}}function o(){"complete"===d.readyState&&i()}function i(){c("mark",["domContent",a()+h.offset],null,"api")}function a(){return E.exists&&performance.now?Math.round(performance.now()):(u=Math.max((new Date).getTime(),u))-h.offset}var u=(new Date).getTime(),c=e("handle"),f=e(2),s=e("ee"),p=window,d=p.document,l="addEventListener",m="attachEvent",w=p.XMLHttpRequest,g=w&&w.prototype;NREUM.o={ST:setTimeout,SI:p.setImmediate,CT:clearTimeout,XHR:w,REQ:p.Request,EV:p.Event,PR:p.Promise,MO:p.MutationObserver};var v=""+location,y={beacon:"bam.nr-data.net",errorBeacon:"bam.nr-data.net",agent:"js-agent.newrelic.com/nr-1071.min.js"},b=w&&g&&g[l]&&!/CriOS/.test(navigator.userAgent),h=t.exports={offset:u,now:a,origin:v,features:{},xhrWrappable:b};e(1),d[l]?(d[l]("DOMContentLoaded",i,!1),p[l]("load",r,!1)):(d[m]("onreadystatechange",o),p[m]("onload",r)),c("mark",["firstbyte",u],null,"api");var x=0,E=e(4)},{}]},{},["loader"]);</script>
</head>
<body>
<h1>hoge</h1>
<div>\t\n<!-- test -->
...
</div>
<div>
  <h1>foo<a href="/a1">a1</a>baz</h1>
  <img
      src="/img1.png"
      draggable="false">
  <br/>
  <img src="/img2.jpg"/>bar<a href="/a2">a2</a>::after
</div><!-- #page -->

</div>
</div>

<meta http-equiv="imagetoolbar" content="no"><!-- disable image toolbar (if any) -->
<!--[if lte IE 8]>
<link rel=\'stylesheet\' id=\'jetpack-carousel-ie8fix-css\'  href=\'https://pozlife.net/wp-content/plugins/jetpack/modules/carousel/jetpack-carousel-ie8fix.css?ver=20121024\' type=\'text/css\' media=\'all\' />
<![endif]-->
<script type="text/javascript">window.NREUM||(NREUM={});NREUM.info={"beacon":"bam.nr-data.net","licenseKey":"f6abab09db","applicationID":"76550678","transactionName":"YwdbYUZZXkYEVBJaV1pNeFZAUV9bSl4IV11M","queueTime":0,"applicationTime":839,"atts":"T0BYFw5DTUg=","errorBeacon":"bam.nr-data.net","agent":""}</script></body>
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

      context 'resource of the url is present' do
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

        context 'when element names are big letters' do
          let(:filter) { %w[h1 a img] }

          it 'gets case-insensitive elements and element names are the same as original ones' do
            actual = Hiroiyomi.read(url, filter: filter)

            h1_elements = actual.select { |e| e.name == 'H1' }
            expect(h1_elements.length).to eq 1
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
