# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    module Query
      # This represents the JSON payload for https://developers.iost.io/docs/en/6-reference/API.html#getcontractstoragefields
      # The API simply returns { "fields": value }, where value is a JSON string defined by a DApp
      class ContractStorageFields
        include Models

        def self.attr_names
          [
            'id',
            'key',
            'by_longest_chain'
          ]
        end
      end
    end
  end
end
