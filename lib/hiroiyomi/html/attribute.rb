# frozen_string_literal: true

require 'open-uri'
require 'openssl'

module Hiroiyomi
  module Html
    # Attribute
    class Attribute
      attr_accessor :name, :value

      def initialize(name, value = nil)
        @name  = name
        @value = value
      end
    end
  end
end
