# frozen_string_literal: true

require 'open-uri'
require 'openssl'

module Hiroiyomi
  module Html
    # Element
    class Element
      include Enumerable

      attr_accessor :name, :content, :attributes

      def initialize(name, content: nil, attributes: [])
        @name       = name
        @content    = content
        @attributes = attributes
      end

      def each
        @attributes.each do |attribute|
          yield attribute
        end
      end
    end
  end
end
