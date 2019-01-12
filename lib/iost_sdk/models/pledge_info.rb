# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class PledgeInfo
      include Models

      def self.attr_names
        [
          'pledger',
          'amount'
        ]
      end
    end
  end
end
