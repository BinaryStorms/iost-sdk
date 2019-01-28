# frozen_string_literal: true

require 'iost_sdk/models/query/transaction'
require 'iost_sdk/models/util/serializer'

module IOSTSdk
  module Models
    module Query
      # This represents the signed transaction payload for https://developers.iost.io/docs/en/6-reference/API.html#sendtx
      class SignedTransaction
        def self.from_transaction(account_name:, tx:, key_pair:)
          raise ArgumentError.new('tx must be an instance of IOSTSdk::Models::Query::Transaction') unless query.is_a?(IOSTSdk::Models::Query::Transaction)

          # assign fields and values from tx
          signed_tx = SignedTransaction.new
          tx.instance_variables.each do |var_name|
            n = var_name.to_s[1..-1].to_sym
            signed_tx.instance_variable_set(var_name, tx.send(n))
            signed_tx.class.send(:define_method, n) do
              instance_variable_get(var_name)
            end
          end
          # calculate hash
          hash_str = signed_tx.calculate_hash
          signature = key_pair.sign(message: hash_str)
          # TODO: return the instance
          # set "publisher"
          signed_tx.instance_variable_set('@publisher', account_name)
          signed_tx.class.send(:define_method, :publisher) { instance_variable_get('@publisher') }
          # set "publisher_sigs"
          signed_tx.instance_variable_set(
            '@publisher_sigs',
            [
              {
                
              }
            ]
          )
          signed_tx.class.send(:define_method, :publisher) { instance_variable_get('@publisher') }
        end

        def calculate_hash
          serializer = IOSTSdk::Models::Util::Serializer
          tx_bytes = serializer.int64_to_bytes(time) +
            serializer.int64_to_bytes(expiration) +
            serializer.int64_to_bytes(gas_ratio * 100) +
            serializer.int64_to_bytes(gas_limit * 100) +
            serializer.int32_to_bytes(chain_id) +
            serializer.array_to_bytes(signers) +
            serializer.array_to_bytes(actions) +
            serializer.array_to_bytes(amount_limit) +
            serializer.array_to_bytes(signatures)

          tx_bytes.pack('C*')
        end
      end
    end
  end
end
