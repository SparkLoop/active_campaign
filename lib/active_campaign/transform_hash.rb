# frozen_string_literal: true

module ActiveCampaign
  #
  # Utility module for manipulating hashes, arrays and values
  #
  # @author Mikael Henriksson <mikael@mhenrixon.com>
  #
  module TransformHash
    module_function

    #
    # Transforms case of all hash keys
    # @note this is used to always output a hash response
    #
    # @param [Hash] hash initial hash before transformation
    # @param [Symbol, Symbol] new_case the new case eg. `:underscore` or `:camelcase, :lower`
    #
    # @return [Hash]
    #
    def transform_keys(hash, *new_case)
      hash.each_with_object({}) do |(key, value), memo|
        memo[transform_key(key, *new_case)] = transform_value(value, *new_case)
      end
    end

    #
    # Transform the provided keys case and lastly symbolize it
    #
    # @param [String, Symbol] key the name of the key to change case
    # @param [Symbol, Symbol] new_case the new case eg. `:underscore` or `:camelcase, :lower`
    #
    # @return [Symbol] the transformed key
    #
    def transform_key(key, *new_case)
      inflect(key.to_s, *new_case).to_sym
    end

    #
    # Transform all values
    # @note used for nested values like hashes and arrays
    #
    # @param [Object] value the value to transform
    # @param [Symbol, Symbol] new_case the new case eg. `:underscore` or `:camelcase, :lower`
    #
    # @return [Object]
    #
    def transform_value(value, *new_case)
      case value
      when Hash
        transform_keys(value, *new_case)
      when Array
        transform_array(value, *new_case)
      else
        value
      end
    end

    def transform_array(collection, *new_case)
      collection.map do |element|
        case element
        when Hash
          transform_keys(element, *new_case)
        else
          element
        end
      end
    end

    #
    # Changes the case of a string
    #
    # @param [String] string the string to change
    # @param [Symbol] style `:underscore` or `:camelcase`
    # @param [Symbol] first_letter `:upper` or `:lower`, only used by `:camelcase`
    #
    # @return [String]
    #
    def inflect(string, style, first_letter = :upper)
      case style
      when :underscore then underscore(string)
      when :camelcase then camelize(string, first_letter)
      else raise ArgumentError, "unknown case #{style.inspect}"
      end
    end

    # The rules below are the ActiveSupport ones without acronyms or namespace (::) handling. They live here
    # so an application's inflection config can't change the keys sent to the API.
    def underscore(string)
      return string unless /[A-Z-]/.match?(string)

      string
        .gsub(/([A-Z])(?=[A-Z][a-z])|([a-z\d])(?=[A-Z])/) { "#{Regexp.last_match(1) || Regexp.last_match(2)}_" }
        .tr('-', '_')
        .downcase
    end

    def camelize(string, first_letter = :upper)
      head = first_letter == :lower ? string.sub(/\A\w/, &:downcase) : string.sub(/\A[a-z\d]*/, &:capitalize)
      head.gsub(/_([a-z\d]*)/i) { Regexp.last_match(1).capitalize }
    end
  end
end
