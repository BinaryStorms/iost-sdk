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
          'signers',
          'publisher',
          'referred_tx',
          'amount_limit',
          'tx_receipt'
        ]
      end
    end
  end
end
