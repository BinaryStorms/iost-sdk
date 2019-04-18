# frozen_string_literal: true

require 'forwardable'
require 'iost_sdk/version'
require 'iost_sdk/crypto'
require 'iost_sdk/errors'
require 'iost_sdk/http/client'
require 'iost_sdk/models/query/transaction'
require 'iost_sdk/models/query/signed_transaction'

module IOSTSdk
  class Main
    extend Forwardable

    attr_reader :client
    attr_accessor :gas_limit, :gas_ratio, :delay,
                  :expiration, :approval_limit_amount,
                  :transaction

    DEFAULTS = {
      gas_limit: 2_000_000,
      gas_ratio: 1,
      delay: 0,
      expiration: 90,
      approval_limit_amount: :unlimited
    }.freeze

    TXN_POLL_CAP = 90
    TXN_STATUS = {
      pending: 'pending',
      success: 'success',
      failed: 'failed'
    }.freeze

    #
    # @param endpoint [String] a URL of the JSON RPC endpoint of IOST
    def initialize(endpoint:)
      @endpoint = endpoint
      @client = IOSTSdk::Http::Client.new(base_url: @endpoint)

      DEFAULTS.each do |k, v|
        instance_variable_set("@#{k}".to_sym, v)
      end
    end

    def_delegators :@client, *IOSTSdk::Http::Client.read_apis.keys

    def sign_and_send(account_name:, key_pair:)
      if @transaction && @transaction.is_valid?
        resp = @client.send_tx(
          transaction: @transaction,
          account_name: account_name,
          key_pair: key_pair
        )

        if resp['pre_tx_receipt']['status_code'] != TXN_STATUS[:success].upcase
          {
            status: TXN_STATUS[:failed],
            txn_hash: resp['hash']
          }
        else
          txn_hash = resp['hash']
          num_tries = 0
          txn_status = TXN_STATUS[:pending]
          txn_receipt = nil
          # poll transaction receipt by hash
          while ![TXN_STATUS[:success], TXN_STATUS[:failed]].include?(txn_status) && num_tries <= TXN_POLL_CAP do
            begin
              txn_receipt = @client.get_tx_receipt_by_tx_hash(hash_value: txn_hash)
            rescue
            end
            txn_status = txn_receipt.status_code.downcase if txn_receipt && txn_receipt.status_code
            num_tries += 1
            sleep(1)
          end

          {
            status: txn_status,
            txn_hash: txn_receipt.tx_hash
          }
        end
      end
    end

    # Create an instance of IOSTSdk::Models::Transaction with an action to call the ABI.
    #
    # @param contract_id [String] a Contract's ID
    # @param abi_name [String] the name of an ABI to call
    # @param abi_args [any] args to the ABI
    # @return a new instance of Transaction
    def call_abi(contract_id:, abi_name:, abi_args:)
      transaction = init_transaction
      transaction.add_action(contract_id: contract_id, action_name: abi_name, action_data: abi_args)
      transaction.set_time_params(expiration: expiration, delay: delay)

      @transaction = transaction
      self
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
      call_abi(
        contract_id: 'token.iost',
        abi_name: :transfer,
        abi_args: [token, from, to, amount.to_s, memo]
      )
      @transaction.add_approve(token: :iost, amount: amount)
      @transaction.set_time_params(expiration: expiration, delay: delay)

      self
    end

    # Create an instance IOSTSdk::Models::Transaction to create a new account
    #
    # @param name [String] the name of the account to be created
    # @param creator [String] the name of the account that's creating a new account
    # @param owner_key [IOSTSdk::Crypto::KeyPair] the owner key of the new account
    # @param active_key [IOSTSdk::Crypto::KeyPair] the active key of the new account
    # @param initial_ram [Integer] the initial RAM of the new account
    # @param initial_gas_pledge [Integer] the initial gas pledge of the new account
    def new_account(name:, creator:, owner_key:, active_key:, initial_ram:, initial_gas_pledge:)
      transaction = init_transaction
      transaction.add_action(
        contract_id: 'auth.iost',
        action_name: :signUp,
        action_data: [name, owner_key.id, active_key.id]
      )

      if initial_ram > 10
        transaction.add_action(
          contract_id: 'ram.iost',
          action_name: :buy,
          action_data: [creator, name, initial_ram]
        )
      end

      if initial_gas_pledge > 0
        transaction.add_action(
          contract_id: 'ram.iost',
          action_name: :buy,
          action_data: [creator, name, initial_gas_pledge.to_s]
        )
      end

      transaction.set_time_params(expiration: expiration, delay: delay)
      @transaction = transaction
      self
    end

    private

    def init_transaction
      time_now = Time.now.utc.to_i * 1_000_000
      transaction = IOSTSdk::Models::Query::Transaction.new.populate(
        model_data: {
          'time' => time_now,
          'expiration' => time_now + delay * 1_000_000,
          'gas_ratio' => gas_ratio,
          'gas_limit' => gas_limit,
          'delay' => delay,
          'chain_id' => 0,
          'signers' => [],
          'actions' => [],
          'amount_limit' => [],
          'signatures' => []
        }
      )
      transaction
    end
  end
end
