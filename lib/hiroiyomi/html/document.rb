# frozen_string_literal: true

require 'open-uri'
require 'openssl'

module Hiroiyomi
  module Html
    # Document
    class Document
      include Enumerable

      attr_accessor :root

      def initialize
        @root = nil
      end

      def element=(element)
        @root = element
      end

      def each
        yield root unless root.nil?
      end
    end
  end
end
