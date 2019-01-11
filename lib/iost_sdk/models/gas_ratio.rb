# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class GasRatio
      include Models

      def self.attr_names
        [
          'lowest_gas_ratio',
          'median_gas_ratio'
        ]
      end
    end
  end
end
