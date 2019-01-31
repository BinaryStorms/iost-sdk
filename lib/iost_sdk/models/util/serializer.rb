# frozen_string_literal: true

module IOSTSdk
  module Models
    module Util
      module Serializer
        def self.int32_to_bytes(int32)
          [int32].pack('L>').unpack('C*')
        end

        def self.int64_to_bytes(int64)
          [int64].pack('Q>').unpack('C*')
        end

        def self.string_to_bytes(str)
          int32_to_bytes(str.size) + str.unpack('C*')
        end

        def self.array_to_bytes(arr, size_prefix=true)
          return int32_to_bytes(0) if !arr || arr.empty?

          data_bytes = arr.map do |elem|
            if elem.class.name == 'Integer'
              int64_to_bytes(elem)
            elsif elem.class.name == 'String'
              string_to_bytes(elem)
            elsif elem.class.name == 'Array'
              array_to_bytes(elem)
            elsif elem.class.name == 'Hash'
              hash_to_bytes(elem)
            elsif elem.respond_to?(:raw_data)
              raw_data_bytes = array_to_bytes(elem.raw_data, false)
              (int32_to_bytes(raw_data_bytes.size) + raw_data_bytes).flatten
            end
          end

          data_bytes.flatten!

          size_prefix ? int32_to_bytes(arr.size) + data_bytes : data_bytes
        end

        def self.hash_to_bytes(h)
          return int32_to_bytes(0) if !h || h.empty?

          # hash to array of key-value pairs, sorted by key
          key_value_pairs = h.sort.map { |k, v| [k.to_s, v] }.flatten
          int32_to_bytes(h.size) + array_to_bytes(key_value_pairs, false)
        end
      end
    end
  end
end
