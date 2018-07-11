# frozen_string_literal: true

require 'open-uri'
require 'openssl'

module Hiroiyomi
  module Html
    # Document
    class Document
      include Enumerable

      attr_accessor :elements

      def initialize(elements = [])
        @elements = elements
      end

      def element=(element)
        @elements.push(element)
      end

      def each
        @elements.each do |element|
          yield element
        end
      end

      def length
        @elements.length
      end

      def empty?
        length.zero?
      end
    end
  end
end
