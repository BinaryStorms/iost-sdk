# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/util/serializer'

module IOSTSdk
  module Models
    class Signature
      include Models

      attr_accessor :public_key_raw, :signature_raw

      ALGORITHM = {
        ED25519: 'ED25519',
        SECP256K1: 'SECP256K1'
      }

      def self.algorithm
        ALGORITHM
      end

      def self.attr_names
        [
          'algorithm',
          'public_key',
          'signature'
        ]
      end

      def byte_string
        serializer = IOSTSdk::Models::Util::Serializer

        byte_string_val = (algorithm == ALGORITHM[:SECP256K1] ? [1] : [2]).pack('C*') +
                          serializer.int32_to_bytes(signature_raw.size).pack('C*') +
                          signature_raw +
                          serializer.int32_to_bytes(public_key_raw.size).pack('C*') +
                          public_key_raw
        serializer.int32_to_bytes(byte_string_val.size).pack('C*') + byte_string_val
      end
    end
  end
end
