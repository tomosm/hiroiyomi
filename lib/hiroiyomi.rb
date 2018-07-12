# frozen_string_literal: true

require 'hiroiyomi/version'
require 'hiroiyomi/root'
require 'hiroiyomi/html_parser'

# Hiroiyomi
module Hiroiyomi
  # @param [String] url URL
  # @param [Array] filter of filtered by name list, e.g. [h1, h2, h3]
  #
  # @return [Array] of Hiroiyomi::Html::Element which has been filtered
  def read(url, filter: [])
    HtmlParser.read(url, filter: filter)
  end

  # rubocop:disable Style/AccessModifierDeclarations
  module_function :read
  # rubocop:enable Style/AccessModifierDeclarations
end
