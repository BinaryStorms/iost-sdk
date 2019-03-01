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

      def raw_data_bytes
        [token, value.to_s]
      end
    end
  end
end
