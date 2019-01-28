# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/amount_limit'

module IOSTSdk
  module Models
    class ABI
      include Models

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
