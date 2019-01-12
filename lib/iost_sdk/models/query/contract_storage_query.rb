# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    module Query
      class ContractStorageQuery
        attr_accessor :id, :field, :key, :by_longest_chain

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
