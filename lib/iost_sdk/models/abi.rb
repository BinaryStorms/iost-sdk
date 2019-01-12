# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class ABI
      include Models

      require 'iost_sdk/models/amount_limit'

      def self.attr_names
        [
          'name',
          'args',
          'amount_limit'
        ]
      end
    end
  end
end
