# frozen_string_literal: true

require 'hiroiyomi/html/dom_parser_helper'

module Hiroiyomi
  module Html
    # Attribute
    class Attribute
      attr_accessor :name, :value

      class << self
        def value_of(file)
          name = DOMParserHelper.extract_string(file)
          return nil if name.empty?
          value = extract_value(file)
          Attribute.new(name, value.empty? ? nil : value)
        end

        private

        # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
        # name=value
        #   Check spaces and > whether value is end
        # name="value"
        # name='value'
        def extract_value(file)
          value = ''
          open  = { "'" => false, '"' => false }
          equal = false

          while (c = file.getc)
            case c
            when "'", '"'
              break if open[c]
              open_keys = open.keys
              open_keys.delete(c)
              if open[open_keys.first]
                value += c
              else
                open[c] = true
              end
            else
              if open.values.any?
                value += c
              elsif c == '='
                equal = true
              elsif ['>', ' '].include?(c)
                file.ungetc(c)
                break
              elsif equal
                value += c
              end
            end
          end
          value
        end
        # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
      end

      def initialize(name, value = nil)
        @name  = name
        @value = value
      end

      def to_s
        "#{name}=\"#{value}\""
      end
    end
  end
end
