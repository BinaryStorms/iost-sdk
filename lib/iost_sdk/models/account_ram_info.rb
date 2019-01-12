# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class AccountRAMInfo
      include Models

      def self.attr_names
        [
          'available',
          'used',
          'total'
        ]
      end
    end
  end
end
