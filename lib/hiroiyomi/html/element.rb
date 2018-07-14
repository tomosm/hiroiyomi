# frozen_string_literal: true

require 'hiroiyomi/html/childable'
require 'hiroiyomi/html/attribute'
require 'hiroiyomi/html/text'

module Hiroiyomi
  module Html
    # rubocop:disable Metrics/ClassLength
    # Element
    class Element
      include Enumerable
      include Childable

      attr_accessor :name, :parent, :attributes, :children

      class << self
        EXCEPTIONAL_ELEMENT_NAME_LIST = %w[script style].freeze

        # rubocop:disable Metrics/MethodLength
        def value_of(file, parent_element = nil)
          # name
          name = extract_element_name(file)

          return parent_element if name.empty?

          # element
          element = Element.new(name, parent: parent_element)

          if parent_element.nil?
            parent_element = element
          else
            parent_element.element = element
          end

          # attributes
          element.attributes = extract_attributes(file)

          # exceptional elements
          if EXCEPTIONAL_ELEMENT_NAME_LIST.include?(name.downcase)
            element.element = extract_exceptional_element_text(file, name)
            return parent_element
          end

          # text if >..., close if /, or open element if >...<
          Text.add_text_to_element_or_parse(file, element)

          # close check. move element children to parent element if not closed. e.g. <img ...>
          element.move_children_to(parent_element) unless validate_closing_element?(file, element)

          parent_element
        end
        # rubocop:enable Metrics/MethodLength

        private

        # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
        def validate_closing_element?(file, element)
          open = false

          while (c = file.getc)
            # /> or </
            if c == '/'
              open = false
              cur_pos = DOMParserHelper.cur_pos(file, c)
              next_c = file.getc
              return true if next_c == '>' # case of />

              # Check whether name is the same or not
              file.ungetc(next_c)
              close_name = DOMParserHelper.extract_string(file)

              return false if close_name.empty?

              is_closed = close_name == element.name
              return true if is_closed

              # Try it again if name is not matched and next close element name does not exist in parent elements
              next unless element.parents?(close_name)

              file.pos = cur_pos
              return false
            elsif c == '<' # case of </
              Text.add_text_to_element_or_parse(file, element)
              open = true
            elsif open
              file.ungetc(c)
              return false
            end
          end
          false
        end
        # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity

        # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        # For script, style. First char must be > after attributes
        def extract_exceptional_element_text(file, name)
          DOMParserHelper.skip_ignore_chars(file)
          file.getc # drop >
          string = ''
          while (c = file.getc)
            if c == '<'
              cur_pos = file.pos
              if file.getc == '/' && name == DOMParserHelper.extract_string(file)
                DOMParserHelper.skip_ignore_chars(file)
                file.getc # drop >
                break
              end
              file.pos = cur_pos
            end
            string += c
          end
          return Text.new(string) unless string.empty?
          nil
        end
        # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

        def skip_comments(file)
          cur_pos = file.pos
          if file.getc == '!'
            # Skip like <!document html>, <!--
            DOMParserHelper.extract_comments(file)
            return true
          end
          file.pos = cur_pos
          false
        end

        def extract_element_name(file)
          while (c = file.getc)
            next unless c == '<'
            next if skip_comments(file)
            return DOMParserHelper.extract_string(file)
          end
          ''
        end

        def extract_attributes(file)
          attributes = []
          while (attribute = Attribute.value_of(file))
            attributes.push(attribute)
          end
          attributes
        end
      end

      def initialize(name, parent: nil, attributes: [], children: [])
        @name       = name
        @parent     = parent
        @attributes = attributes
        @children   = children
      end

      def element=(element)
        @children.push(element) unless element.nil?
      end

      def each
        @children.each do |child|
          yield child
        end
      end

      def move_children_to(element)
        each do |child|
          element.element = child
        end
        children.clear
      end

      def parents?(name)
        return false if parent.nil?
        return true if parent.name == name
        parent.parents?(name)
      end

      def deep_select(search_name_list = [], searched = [])
        searched.push(self) if search_name_list.include?(name.downcase)
        children.each do |child|
          next if child.text?
          if search_name_list.include?(child.name.downcase)
            searched.push(child)
          else
            child.deep_select(search_name_list, searched)
          end
        end
        searched
      end

      def inner_html
        children.map(&:to_s).join
      end

      def to_s
        attrs = attributes.map(&:to_s).join(' ')
        attrs = ' ' + attrs unless attrs.empty?
        "<#{name}#{attrs}>#{inner_html}</#{name}>"
      end
    end
    # rubocop:enable Metrics/ClassLength
  end
end
