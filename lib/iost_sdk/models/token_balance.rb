# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class TokenBalance
      include Models

      require 'iost_sdk/models/frozen_balance'

      def self.attr_names
        [
          'balance',
          'frozen_balances'
        ]
      end
    end
  end
end
