# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class TransactionRequest
      include Models

      require 'iost_sdk/models/action'
      require 'iost_sdk/models/amount_limit'
      require 'iost_sdk/models/signature'

      def self.attr_names
        [
          'time',
          'expiration',
          'gas_ratio',
          'gas_limit',
          'delay',
          'actions',
          'amount_limit',
          'publisher',
          'publisher_sigs',
          'signers',
          'signatures'
        ]
      end
    end
  end
end
