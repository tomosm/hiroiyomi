# frozen_string_literal: true

require 'open-uri'
require 'openssl'

module Hiroiyomi
  module Html
    # Element
    class Element
      include Enumerable

      attr_accessor :name, :content, :attributes, :children

      def initialize(name, content: nil, attributes: [], children: [])
        @name       = name
        @content    = content
        @attributes = attributes
        @children   = children
      end

      def element=(element)
        @children.push(element)
      end

      def each
        @children.each do |child|
          yield child
        end
      end
    end
  end
end
