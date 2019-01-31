# frozen_string_literal: true

require 'iost_sdk/version'
require 'iost_sdk/http/client'
require 'iost_sdk/models/query/transaction'
require 'iost_sdk/models/query/signed_transaction'

module IOSTSdk
  class Main
    attr_accessor :gas_limit, :gas_ratio, :delay, :expiration

    DEFAULTS = {
      gas_limit: 1_000_000,
      gas_ratio: 1,
      delay: 0,
      expiration: 90_000_000_000
    }.freeze

    def initialize
      DEFAULTS.each do |k, v|
        instance_variable_set("@#{k}".to_sym, v)
      end
    end

    # Create an instance of IOSTSdk::Models::Transaction with an action to call the ABI.
    #
    # @param contract_id [String] a Contract's ID
    # @param abi_name [String] the name of an ABI to call
    # @param abi_args [any] args to the ABI
    # @return a new instance of Transaction
    def call_abi(contract_id:, abi_name:, abi_args:)
      time_now = Time.now.utc.to_i * 1_000_000
      transaction = IOSTSdk::Models::Query::Transaction.new.populate(
        model_data: {
          'time' => time_now,
          'expiration' => time_now + delay * 1_000_000,
          'gas_ratio' => gas_ratio,
          'gas_limit' => gas_limit,
          'delay' => delay,
          'chain_id' => nil,
          'signers' => [],
          'actions' => [],
          'amount_limit' => [],
          'signatures' => []
        }
      )
      transaction.add_action(contract_id: contract_id, action_name: abi_name, action_data: abi_args)
      transaction.add_approve(token: '*', amount: :unlimited)
      transaction
    end

    # Create an instance IOSTSdk::Models::Transaction with an action to transfer tokens
    #
    # @param token [String] name of the token in the transfer
    # @param from [String] sender
    # @param to [String] recipient
    # @param amount [Integer] amount to transfer
    # @param memo [String] memo/notes for the transfer
    # @return a new instance of Transaction
    def transfer(token:, from:, to:, amount:, memo:)
      transaction = call_abi(
        contract_id: 'token.iost',
        abi_name: :transfer,
        abi_args: [token, from, to, amount, memo]
      )
      transaction.add_approve(token: :iost, amount: amount)
      transaction
    end
  end
end
