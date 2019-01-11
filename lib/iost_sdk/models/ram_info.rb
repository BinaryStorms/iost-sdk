# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class RAMInfo
      include Models

      def self.attr_names
        [
          'available_ram',
          'buy_price',
          'sell_price',
          'total_ram',
          'used_ram'
        ]
      end
    end
  end
end
