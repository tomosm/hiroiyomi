# frozen_string_literal: true

require 'hiroiyomi/html/element'
require 'hiroiyomi/html/attribute'
require 'hiroiyomi/html/text'
require 'hiroiyomi/html/dom_parser_helper'

module Hiroiyomi
  module Html
    # Document
    class Document
      include Enumerable

      attr_accessor :root

      class << self
        def value_of(file)
          document = new
          return document if file.nil?

          document.root = Element.value_of(file)
          document
        end
      end

      def initialize
        @root = nil
      end

      def each
        yield root unless root.nil?
      end
    end
  end
end
