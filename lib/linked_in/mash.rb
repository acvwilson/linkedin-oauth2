require 'hashie'
require 'xmlsimple'
require 'active_support/core_ext/string/inflections.rb'

module LinkedIn
  class Mash < ::Hashie::Mash

    # a simple helper to convert an xml string to a Mash
    def self.from_xml(xml_string)
      result_hash = xml_string.nil? || xml_string == "" ? {} : ::XmlSimple.xml_in(xml_string, forcearray: false)
      result_hash = clean_search_hash(result_hash)
      new(result_hash)
    end

    # returns a Date if we have year, month and day, and no conflicting key
    def to_date
      if !self.has_key?('to_date') && contains_date_fields?
        Date.civil(self.year, self.month, self.day)
      else
        super
      end
    end

    def timestamp
      value = self['timestamp']
      if value.kind_of? Integer
        value = value / 1000 if value > 9999999999
        Time.at(value)
      else
        value
      end
    end

    protected

      # XML to hash conversions always end up with weird things like this:
      # {
      #   "people" => {
      #     "person" => [Array of people],
      #     "count"  => 25
      #   }
      # }
      #
      # This will return a more reasonable results like this:
      # {
      #   "people" => {
      #     "data" => [Array of people],
      #     "count"  => 25
      #   }
      # }
      def self.clean_search_hash(hash)
        hash.dup.each do |key, value|
          if hash[key].is_a?(Hash) && collection = hash[key].delete(key.singularize)
            hash[key]['data'] = collection
          end

          if hash[key].is_a?(Array) && collection = hash.delete(key)
            hash['data'] = collection
          end
        end

        hash
      end

      def contains_date_fields?
        self.year? && self.month? && self.day?
      end

      # overload the convert_key mash method so that the LinkedIn
      # keys are made a little more ruby-ish
      def convert_key(key)
        case key.to_s
        when '_key'
          'id'
        when '_total'
          'total'
        when 'values'
          'all'
        when 'numResults'
          'total_results'
        else
          underscore(key)
        end
      end

      # borrowed from ActiveSupport
      # no need require an entire lib when we only need one method
      def underscore(camel_cased_word)
        word = camel_cased_word.to_s.dup
        word.gsub!(/::/, '/')
        word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
        word.tr!("-", "_")
        word.downcase!
        word
      end

  end
end
