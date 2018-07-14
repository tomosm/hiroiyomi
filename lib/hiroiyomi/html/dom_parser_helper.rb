# frozen_string_literal: true

module Hiroiyomi
  module Html
    # DOMParserHelper
    class DOMParserHelper
      class << self
        def cur_pos(file, char)
          file.ungetc(char) # In order to get current position correctly
          cur_pos = file.pos
          file.getc # drop <
          cur_pos
        end

        def skip_ignore_chars(file)
          while (c = file.getc)
            unless /[\t\n\r\s]/.match?(c)
              file.ungetc(c)
              return
            end
          end
        end

        # rubocop:disable Metrics/MethodLength
        # string of <.+ or ".+"
        def extract_string(file)
          skip_ignore_chars(file)
          string = ''
          while (c = file.getc)
            case c
            when /[\w-]/
              string += c
            else
              file.ungetc(c)
              break
            end
          end
          string.gsub(/[\t\r\n]/, '').strip
        end
        # rubocop:enable Metrics/MethodLength

        # rubocop:disable Metrics/MethodLength
        def extract_text_with_symbols(file, char_before_last_char = ']', last_char = '>')
          string = ''
          while (c = file.getc)
            string += c
            next_c = file.getc
            if c == char_before_last_char && last_char == next_c
              string += next_c
              break
            end
            file.ungetc(next_c)
          end
          string
        end
        # rubocop:enable Metrics/MethodLength

        # after <![
        def extract_cddata(file)
          cur_pos = file.pos
          c = file.getc
          return "#{c}#{extract_text_with_symbols(file, ']')}" if c == '[' # CDDATA
          file.pos = cur_pos
          nil
        end

        # after <!-
        def extract_comments(file)
          cur_pos = file.pos
          c = file.getc
          return "#{c}#{extract_text_with_symbols(file, '-')}" if c == '-' # Comment
          file.pos = cur_pos
          nil
        end
      end
    end
  end
end
