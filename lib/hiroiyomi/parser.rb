# frozen_string_literal: true

require 'open-uri'
require 'openssl'

module Hiroiyomi
  # Parser
  module Parser
    def self.included(klass)
      # @param [String] url URL
      # @param [Array] filter of filtered by name list, e.g. [h1, h2, h3]
      #
      # @return [Array] of Hiroiyomi::Html::Element which has been filtered
      def klass.read(url, filter:)
        new.read(url, filter: filter)
      end
    end

    # @param [String] url URL
    # @param [Array] filter of filtered by name list, e.g. [h1, h2, h3]
    #
    # @return [Array] of Hiroiyomi::Html::Element which has been filtered
    def read(url, filter:)
      @open_file = open_url(url)
      do_filter(do_parse(@open_file), filter: filter)
    ensure
      @open_file&.unlink
    end

    private

    def open_url(url)
      OpenURI.open_uri(url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)
    end

    def do_parse
      raise NoMethodError.new, "#{__method__} need to be overridden."
    end

    def do_filter(data, *)
      data
    end
  end
end
