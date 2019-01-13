# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    module Query
      class ContractStorageQuery
        attr_accessor :id, :field, :key, :by_longest_chain

        # This represents the JSON payload for https://developers.iost.io/docs/en/6-reference/API.html#getcontractstorage
        # The API simply returns { "data": value }, where value is a JSON string defined by a DApp
        def initialize(id:, field:, key:, by_longest_chain:)
          @id = id
          @field = field
          @key = key
          @by_longest_chain = by_longest_chain
        end
      end
    end
  end
end
