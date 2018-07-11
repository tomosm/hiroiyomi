# frozen_string_literal: true

require 'open-uri'
require 'openssl'

module Hiroiyomi
  # Parser
  module Parser
    def self.included(klass)
      # @param [String] url URL
      # @param [Hiroiyomi::Html::Document] filter filtered by name list of Hiroiyomi::Html::Element
      #
      # @return [Hiroiyomi::Html::Document] Hiroiyomi::Html::Document which has extracted data
      def klass.parse(url, filter:)
        new.parse(url, filter: filter)
      end
    end

    # @param [String] url URL
    # @param [Hiroiyomi::Html::Document] filter filtered by name list of Hiroiyomi::Html::Element
    #
    # @return [Hiroiyomi::Html::Document] Hiroiyomi::Html::Document which has extracted data
    def parse(url, filter:)
      @open_file = open_url(url)
      do_parse(@open_file, filter: filter)
    ensure
      @open_file&.unlink
    end

    private

    def open_url(url)
      OpenURI.open_uri(url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)
    end

    def do_parse(*)
      raise NoMethodError.new('Unsupported', __method__)
    end
  end
end
