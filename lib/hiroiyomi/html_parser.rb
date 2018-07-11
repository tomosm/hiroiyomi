# frozen_string_literal: true

require 'hiroiyomi/parser'
require 'hiroiyomi/html/document'
require 'hiroiyomi/html/element'
require 'hiroiyomi/html/attribute'

module Hiroiyomi
  # HtmlParser
  class HtmlParser
    include Parser

    private

    def do_parse(file, filter:)
      document = Html::Document.new
      return document if file.nil?

      @filter_element_name_list = filter.nil? ? [] : filter.map(&:name)
      track_element(file, document)
      document
    end

    # ===
    # Extract HTML Element
    # ===

    def track_element(file, document)
      while (c = file.getc)
        if c == '<'
          extract_element(file, document)
        end
      end
    end

    def extract_element(file, document)
      name = extract_name(file)
      return nil if skip_element?(name)

      attributes       = extract_attributes(file)
      content          = extract_content(file, document)

      document.element = Html::Element.new(name, content: content, attributes: attributes) if validate_closing_element?(name, file)
    end

    def skip_element?(name)
      name.empty? || (!@filter_element_name_list.empty? && !@filter_element_name_list.include?(name))
    end

    # rubocop:disable Metrics/MethodLength
    def extract_name(file, skip_space: false)
      name = ''
      while (c = file.getc)
        case c
        when /[\w-]/
          name += c
        else
          next if skip_space && c =~ /\s/
          file.ungetc(c)
          break
        end
      end
      name
    end
    # rubocop:enable Metrics/MethodLength

    def extract_attributes(file)
      attributes = []
      while (attribute = extract_attribute(file))
        attributes.push(attribute)
      end
      attributes
    end

    # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
    def extract_attribute(file)
      name = extract_name(file, skip_space: true)
      return nil if name.empty?

      value = ''
      open  = false
      while (c = file.getc)
        case c
        when '"'
          break if open
          open = true
        else
          value += c if open
        end
      end

      Html::Attribute.new(name, value.empty? ? nil : value)
    end
    # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity

    # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
    def extract_content(file, document)
      content = ''
      close   = false
      while (c = file.getc)
        case c
        when '/'
          unless close
            file.ungetc(c)
            break
          end
        when '<'
          extract_element(file, document)
          close = false
        when '>'
          close ||= true
        else
          content += c if close
        end
      end
      content.empty? ? nil : content
    end
    # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity

    def validate_closing_element?(element_name, file)
      open = false
      while (c = file.getc)
        return !open || extract_name(file) == element_name if c == '/'
        open = true if c == '<'
      end
      false
    end
  end
end
