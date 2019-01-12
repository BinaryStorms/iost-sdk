# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class FrozenBalance
      include Models

      def self.attr_names
        [
          'amount',
          'time'
        ]
      end
    end
  end
end
