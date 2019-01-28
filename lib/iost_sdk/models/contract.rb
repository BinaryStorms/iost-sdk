# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/abi'

module IOSTSdk
  module Models
    class Contract
      include Models

      def self.attr_names
        [
          'id',
          'code',
          'language',
          'version',
          'abis'
        ]
      end
    end
  end
end
