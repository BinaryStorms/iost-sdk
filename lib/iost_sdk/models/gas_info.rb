# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class GasInfo
      include Models

      require 'iost_sdk/models/pledge_info'

      def self.attr_names
        [
          'current_total',
          'transferable_gas',
          'pledge_gas',
          'increase_speed',
          'limit',
          'pledged_info'
        ]
      end
    end
  end
end
