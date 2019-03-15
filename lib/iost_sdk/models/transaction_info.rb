# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/transaction'

module IOSTSdk
  module Models
    class TransactionInfo
      include Models

      def self.attr_names
        [
          'status',
          'transaction',
          'block_number'
        ]
      end
    end
  end
end
