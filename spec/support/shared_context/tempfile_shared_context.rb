# frozen_string_literal: true

shared_context 'tempfile_shared_context' do
  let(:tempfile) { Tempfile.open }
  before do
    Hiroiyomi::HtmlParser.any_instance.stub(:open_url).and_return(tempfile)
  end
  after do
    tempfile.unlink
  end
end
