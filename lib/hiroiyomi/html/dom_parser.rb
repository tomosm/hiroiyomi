# frozen_string_literal: true

require 'hiroiyomi/parser'
require 'hiroiyomi/html/document'

module Hiroiyomi
  module Html
    # DOMParser
    class DOMParser
      include Parser

      private

      def do_parse(file)
        Document.value_of(file)
      end

      def do_filter(document, filter:, is_deep: true)
        filtered_elements = filter_element(document, filter, [])
        return filtered_elements unless is_deep

        filtered_elements.map { |e| e.deep_select(filter) }.flatten
      end

      def filter_element(element, filter, filtered_elements)
        element.each do |child|
          next if child.text?
          if filter&.include?(child.name.downcase)
            filtered_elements.push(child)
          else
            filter_element(child, filter, filtered_elements)
          end
        end
        filtered_elements
      end
    end
  end
end
