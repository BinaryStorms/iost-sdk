# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class Block
      include Models

      require 'iost_sdk/models/transaction'
      require 'iost_sdk/models/info'

      def self.attr_names
        [
          'hash',
          'version',
          'parent_hash',
          'tx_merkle_hash',
          'tx_receipt_merkle_hash',
          'number',
          'witness',
          'time',
          'gas_usage',
          'tx_count',
          'info',
          'transactions'
        ]
      end
    end
  end
end
