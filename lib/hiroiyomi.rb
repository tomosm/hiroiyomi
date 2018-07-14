# frozen_string_literal: true

require 'hiroiyomi/version'
require 'hiroiyomi/root'
require 'hiroiyomi/html/dom_parser'

# Hiroiyomi
module Hiroiyomi
  # @param [String] url URL
  # @param [Array] filter of filtered by name list, e.g. [h1, h2, h3]
  # @param [Boolean] is_deep Whether result is filtered into children
  #
  # @return [Array] of Hiroiyomi::Html::Element which has been filtered
  def read(url, filter: [], is_deep: true)
    Html::DOMParser.read(url, filter: filter, is_deep: is_deep)
  end

  # rubocop:disable Style/AccessModifierDeclarations
  module_function :read
  # rubocop:enable Style/AccessModifierDeclarations
end
