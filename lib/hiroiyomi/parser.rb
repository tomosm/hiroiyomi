# frozen_string_literal: true

require 'open-uri'
require 'openssl'

module Hiroiyomi
  # Parser
  module Parser
    def self.included(klass)
      def klass.read(url, filter:, is_deep: true)
        new.read(url, filter: filter, is_deep: is_deep)
      end
    end

    def read(url, filter:, is_deep: true)
      @open_file = open_url(url)
      do_filter(do_parse(@open_file), filter: filter, is_deep: is_deep)
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
