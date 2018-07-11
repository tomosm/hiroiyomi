# frozen_string_literal: true

require 'hiroiyomi/version'
require 'hiroiyomi/root'
require 'hiroiyomi/html_parser'

# Hiroiyomi
module Hiroiyomi
  # @param [String] url URL
  # @param [Hiroiyomi::Html::Document] filter filtered by name list of Hiroiyomi::Html::Element
  #
  # @return [Hiroiyomi::Html::Document] Hiroiyomi::Html::Document which has extracted data
  def parse(url, filter: nil)
    HtmlParser.parse(url, filter: filter)
  end

  # rubocop:disable Style/AccessModifierDeclarations
  module_function :parse
  # rubocop:enable Style/AccessModifierDeclarations
end
