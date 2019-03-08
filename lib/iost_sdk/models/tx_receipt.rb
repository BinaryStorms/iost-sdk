# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/receipt'

module IOSTSdk
  module Models
    class TxReceipt
      include Models

      def self.attr_names
        [
          'tx_hash',
          'gas_usage',
          'ram_usage',
          'status_code',
          'message',
          'returns',
          'receipts'
        ]
      end
    end
  end
end
