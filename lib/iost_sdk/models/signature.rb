# frozen_string_literal: true

require 'iost_sdk/models'

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

      def raw_data
        [algorithm, public_key, signature]
      end
    end
  end
end
