# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class Transaction
      include Models

      require 'iost_sdk/models/action'
      require 'iost_sdk/models/amount_limit'
      require 'iost_sdk/models/tx_receipt'

      def self.attr_names
        [
          'hash',
          'time',
          'expiration',
          'gas_ratio',
          'gas_limit',
          'delay',
          'actions',
          'chain_id',
          'signers',
          'publisher',
          'referred_tx',
          'amount_limit',
          'tx_receipt'
        ]
      end

      def to_bytes
        # serialization order (https://github.com/iost-official/iost.js/blob/9d3e5d0565e4f67b699f2aab0b62d338f537e91c/lib/structs.js#L73)
        # 1. time
        # 2. expiration
        # 3. gas_ratio * 100
        # 4. gas_limit * 100
        # 5. delay
        # 6. chain_id
        # 7. signers
        # 8. actions
        # 9. amount_limit
        # 10. signatures

        bytes = []
        
      end
    end
  end
end
