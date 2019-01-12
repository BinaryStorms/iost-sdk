# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class AmountLimit
      include Models

      def self.attr_names
        [
          'token',
          'value'
        ]
      end
    end
  end
end
