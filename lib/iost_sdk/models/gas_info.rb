# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/pledge_info'

module IOSTSdk
  module Models
    class GasInfo
      include Models

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
