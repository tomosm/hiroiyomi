# Hiroiyomi

Hiroiyomi is an HTML parser and provides a filter feature by tag names.
          
## Features

- Filter HTML page content by tag names

## Synopsis

Hiroiyomi reads a HTML raw content from a specific url and builds DOM structures inside. After the structures are built, the DOM elements are filtered. Here are the steps of how to build a element from raw string.

e.g. `<h1 class="title">Hiroiyomi</1>`

1. Check one char until `<` appears.
1. After the '<', check next sequential chars and store them as element name until space char appears.
1. After the space char, check next sequential chars and store them as attribute name until space char, `>`, `/`, `=`, `"`, or `'` appears.
1. After `>` or `/`, there is no attribute value. After `=`, `"`, or `'`, check next sequential chars and store them as attribute value until space char, `>`, `/`, `"`, or `'` appears.
1. After `/`, the element does not have close tag.
1. After `>`, check next sequential chars and store them as text of the element child until new `<` appears,
1. After `</`, check next sequential chars and compare them with the element name whether the both are the same.
1. If the both the element name and the name after `</` are the same, the element is build as DOM element in this case.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hiroiyomi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hiroiyomi

## Usage

```ruby
# @param [String] url URL
# @param [Array] filter of filtered by name list, e.g. [h1, h2, h3]
# @param [Boolean] is_deep Whether result is filtered into children
#
# @return [Array] of Hiroiyomi::Html::Element which has been filtered
Hiroiyomi.read('https://github.com', filter: %w[h1 h2 h3 a link], is_deep: true) 
```

## Requirement

- Ruby 2.5.1+

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tomosm/hiroiyomi.

