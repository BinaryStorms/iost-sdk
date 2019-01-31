# frozen_string_literal: true

require 'sha3'
require 'base58'
require 'iost_sdk/models/query/transaction'
require 'iost_sdk/models/util/serializer'

module IOSTSdk
  module Models
    module Query
      # This represents the signed transaction payload for https://developers.iost.io/docs/en/6-reference/API.html#sendtx
      class SignedTransaction
        def self.from_transaction(transaction:)
          raise ArgumentError.new('tx must be an instance of IOSTSdk::Models::Query::Transaction') unless
            transaction.is_a?(IOSTSdk::Models::Query::Transaction)

          # assign fields and values from tx
          signed_tx = SignedTransaction.new
          transaction.instance_variables.each do |var_name|
            n = var_name.to_s[1..-1].to_sym
            signed_tx.instance_variable_set(var_name, transaction.send(n))
            signed_tx.class.send(:define_method, n) do
              instance_variable_get(var_name)
            end
          end

          signed_tx
        end

        def hash_value(include_signatures:)
          byte_string = bytes_for_signature
          if include_signatures
            serializer = IOSTSdk::Models::Util::Serializer
            byte_string = byte_string +
              serializer.int32_to_bytes(signatures.size) +
              signatures.map(&:bytes).flatten
          end

          SHA3::Digest.new(:sha256)
                      .update(byte_string.pack('C*'))
                      .digest
        end

        def add_sig(key_pair:)
          signature = key_pair.sign(message: hash_value(include_signatures: false))
          @signatures ||= []
          @signatures << IOSTSdk::Models::Signature.new.populate(
            model_data: {
              'algorithm' => key_pair.algo,
              'public_key' => [key_pair.public_key_raw].pack('m0'),
              'signature' => [signature].pack('m0')
            }
          )

          self
        end

        def add_publisher_sig(account_name:, key_pair:)
          signature = key_pair.sign(message: hash_value(include_signatures: true))
          # set "publisher"
          instance_variable_set('@publisher', account_name)
          self.class.send(:define_method, :publisher) { instance_variable_get('@publisher') }
          # set "publisher_sigs"
          instance_variable_set(
            '@publisher_sigs',
            [
              IOSTSdk::Models::Signature.new.populate(
                model_data: {
                  'algorithm' => key_pair.algo,
                  'public_key' => [key_pair.public_key_raw].pack('m0'),
                  'signature' => [signature].pack('m0')
                }
              )
            ]
          )
          self.class.send(:define_method, :publisher_sigs) { instance_variable_get('@publisher_sigs') }
          self
        end

        private

        def bytes_for_signature
          serializer = IOSTSdk::Models::Util::Serializer
          tx_bytes = serializer.int64_to_bytes(time) +
            serializer.int64_to_bytes(expiration) +
            serializer.int64_to_bytes(gas_ratio * 100) +
            serializer.int64_to_bytes(gas_limit * 100) +
            serializer.int32_to_bytes(chain_id) +
            serializer.int64_to_bytes(delay) +
            # adding "reserved" as a fixed value
            serializer.int32_to_bytes(0) +
            serializer.array_to_bytes(signers) +
            serializer.array_to_bytes(actions) +
            serializer.array_to_bytes(amount_limit)

          tx_bytes
        end
      end
    end
  end
end
