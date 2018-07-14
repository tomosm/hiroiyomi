# frozen_string_literal: true

require 'hiroiyomi/html/childable'
require 'hiroiyomi/html/element'

module Hiroiyomi
  module Html
    # Text
    class Text
      include Childable
      attr_accessor :value

      class << self
        # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity

        # Start from > after attributes
        def add_text_to_element_or_parse(file, element)
          close = false
          string = ''

          append_string = lambda { |str|
            string += str if close
          }

          add_text_to_element = lambda { |str = ''|
            append_string.call str
            string = string.gsub(/[\t\r\n]/, '').strip
            unless string.empty?
              element.element = new(string)
              string = ''
            end
          }

          while (c = file.getc)
            case c
            when '/' # /* */ ?
              cur_pos = DOMParserHelper.cur_pos(file, c)
              next_c = file.getc
              if next_c == '*'
                add_text_to_element.call "#{c}#{next_c}#{DOMParserHelper.extract_text_with_symbols(file, next_c, c)}"
                next
              end
              # / is of />
              file.pos = cur_pos
              break
            when '<'
              cur_pos = DOMParserHelper.cur_pos(file, c)
              next_c = file.getc
              # rubocop:disable Metrics/BlockNesting
              if next_c == '!'
                cddata = DOMParserHelper.extract_cddata(file)
                unless cddata.nil?
                  add_text_to_element.call "#{c}#{next_c}#{cddata}" unless cddata.empty?
                  next
                end
                # Drop comment
                comment = DOMParserHelper.extract_comments(file)
                next unless comment.nil?
              end
              # rubocop:enable Metrics/BlockNesting

              file.pos = cur_pos

              add_text_to_element.call

              # Next element from < char
              element = Element.value_of(file, element)

              # file.getc # drop <
            when '>' # > is of >...
              close = true
            else
              append_string.call c
            end
          end

          add_text_to_element.call
          element
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity

      def initialize(value)
        @value = value
      end

      def text?
        true
      end

      def to_s
        value
      end
    end
  end
end
