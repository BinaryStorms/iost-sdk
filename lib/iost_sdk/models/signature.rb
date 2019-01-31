# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/util/serializer'

module IOSTSdk
  module Models
    class Signature
      include Models

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

      def bytes
        serializer = IOSTSdk::Models::Util::Serializer
        public_key_raw = public_key.unpack('m0').first
        signature_raw = signature.unpack('m0').first

        byte_value = (algorithm == ALGORITHM[:SECP256K1] ? [1] : [2]) +
                          serializer.int32_to_bytes(signature_raw.size) +
                          signature_raw.unpack('C*') +
                          serializer.int32_to_bytes(public_key_raw.size) +
                          public_key_raw.unpack('C*')
        serializer.int32_to_bytes(byte_value.size) + byte_value
      end
    end
  end
end
