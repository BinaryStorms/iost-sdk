# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class TxReceipt
      include Models

      require 'iost_sdk/models/receipt'

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
