# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class ContractStorageInfo
      include Models

      require 'iost_sdk/models/amount_limit'

      def self.attr_names
        [
          'pubkey',
          'loc',
          'url',
          'netId',
          'online',
          'registerFee'
        ]
      end
    end
  end
end
