# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/amount_limit'
require 'iost_sdk/models/action'
require 'iost_sdk/models/signature'

module IOSTSdk
  module Models
    module Query
      # This represents the JSON payload for https://developers.iost.io/docs/en/6-reference/API.html#sendtx
      class Transaction
        include Models

        def self.attr_names
          [
            'time',
            'expiration',
            'gas_ratio',
            'gas_limit',
            'delay',
            'chain_id',
            'signers',
            'actions',
            'amount_limit',
            'signatures'
          ]
        end
      end
    end
  end
end
