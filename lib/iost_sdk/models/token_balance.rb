# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/frozen_balance'

module IOSTSdk
  module Models
    class TokenBalance
      include Models

      def self.attr_names
        [
          'balance',
          'frozen_balances'
        ]
      end
    end
  end
end
