# frozen_string_literal: true

require 'json'
require 'httparty'
require 'iost_sdk/models/query/signed_transaction'
require 'iost_sdk/http/http_request_error'
require 'iost_sdk/string'

module IOSTSdk
  module Http
    class Client
      # key: method name
      # value: an array of args
      METHODS = {
        get_node_info: [],
        get_chain_info: [],
        get_gas_ratio: [],
        get_ram_info: [],
        get_tx_by_hash: [:hash_value],
        get_tx_receipt_by_tx_hash: [:hash_value],
        get_block_by_hash: [:hash_value, :complete],
        get_block_by_number: [:number, :complete],
        get_account: [:name, :by_longest_chain],
        get_token_balance: [:account_name, :token_name, :by_longest_chain],
        get_contract: [:id, :by_longest_chain],
        get_contract_storage: [:query],
        get_contract_storage_fields: [:query],
        send_tx: [:transaction, :account_name, :key_pair]
        # TODO: exec_tx
        # TODO: subscribe
      }

      def initialize(base_url:)
        @base_url = base_url

        METHODS.each do |method_name, method_args|
          # require the file
          require "iost_sdk/http/#{method_name}"
          # define the method
          self.class.send(:define_method, method_name) do |**args|
            # extract match args for the call
            raise ArgumentError.new('Invalid method arguments.') unless
              Set.new(method_args).subset?(Set.new(args.keys))

            valid_args = method_args.reduce({}) do |memo, k|
              memo[k] = args[k]
              memo
            end
            # init and invoke
            class_name = IOSTSdk::String.camelize(method_name)
            clazz = IOSTSdk::String.classify("IOSTSdk::Http::#{class_name}")
            clazz.new.invoke(valid_args.merge(base_url: @base_url))
          end
        end
      end
    end
  end
end
