# frozen_string_literal: true

require 'hiroiyomi/parser'
require 'hiroiyomi/html/document'
require 'hiroiyomi/html/element'
require 'hiroiyomi/html/attribute'

module Hiroiyomi
  # HtmlParser
  # rubocop:disable Metrics/ClassLength
  class HtmlParser
    include Parser

    private

    def do_parse(file)
      document = Html::Document.new
      return document if file.nil?

      track_element(file, document)
    end

    # ========
    # Extract HTML Element
    # ========

    def track_element(file, document)
      while (c = file.getc)
        break if c == '<' && extract_element(file, document)
      end
      document
    end

    def extract_element(file, document)
      name = extract_name(file)
      return false if name.empty?

      attributes       = extract_attributes(file)
      element          = Html::Element.new(name, attributes: attributes)
      content          = extract_content(file, element)
      element.content  = content unless content.empty?

      document.element = element if validate_closing_element?(name, file)
      true
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

    # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
    def extract_content(file, document)
      content = ''
      close   = false

      append_content = lambda { |str|
        content += str if close
      }

      while (c = file.getc)
        case c
        when '/'
          # /*<![CDATA[*/!function(e,t,r){function ... ])/*]]>*/
          next_c = file.getc
          if next_c == '*'
            append_content.call(c + next_c)
            content += extract_content_of_cddata(file)
          elsif !close
            file.ungetc(c)
            break
          end
        when '<'
          extract_element(file, document)
          # file.ungetc(c)
          # track_element(file, document)
          close = false
        when '>'
          close ||= true
        else
          append_content.call(c)
        end
      end
      content
    end

    # /*<![CDATA[*/!function(e,t,r){function ... ])/*]]>*/
    def extract_content_of_cddata(file)
      content      = ''
      start_cddata = false

      append_content = lambda { |str|
        content += str
      }

      while (c = file.getc)
        case c
        when '/'
          next_c = file.getc
          append_content.call(c + next_c) if next_c == '*'
        when '*' # /*<![CDATA[*/!function(e,t,r){function ... ])/*]]>*/
          next_c = file.getc
          unless next_c == '/'
            file.ungetc(next_c)
            next_c = ''
          end
          start_cddata = !start_cddata
          append_content.call(c + next_c)
          return content unless start_cddata
        else
          append_content.call(c)
        end
      end
      content
    end

    # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize

    def validate_closing_element?(element_name, file)
      open = false
      while (c = file.getc)
        return !open || extract_name(file) == element_name if c == '/'
        open = true if c == '<'
      end
      false
    end

    # ========
    # Filter HTML Element
    # ========

    def do_filter(document, filter:)
      filter_element(document, filter, [])
    end

    def filter_element(element, filter, extracted_elements)
      element.each do |child|
        if filter&.include?(child.name)
          extracted_elements.push(child)
        else
          filter_element(child, filter, extracted_elements)
        end
      end
      extracted_elements
    end
  end
  # rubocop:enable Metrics/ClassLength
end
