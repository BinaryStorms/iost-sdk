# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class Contract
      include Models

      require 'iost_sdk/models/abi'

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
