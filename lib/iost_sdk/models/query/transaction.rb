# frozen_string_literal: true

require 'json'
require 'iost_sdk/models'
require 'iost_sdk/models/amount_limit'
require 'iost_sdk/models/action'
require 'iost_sdk/models/signature'

module IOSTSdk
  module Models
    module Query
      class Transaction
        include Models

        attr_accessor :chain_id, :time, :expiration

        def self.attr_names
          [
            'time',
            'expiration',
            'gas_ratio',
            'gas_limit',
            'delay',
            'chain_id',
            'reserved',
            'signers',
            'actions',
            'amount_limit',
            'signatures'
          ]
        end

        # set the +time+ implicitly, and set +expiration+ and +delay+ explicitly
        #
        # @param expiration [Integer] number of seconds, since creation, the transaction will expire in
        # @param delay [Integer] the delay
        def set_time_params(expiration:, delay:)
          time_now = (Time.now.utc.to_f * 1000).to_i * 1_000_000

          @time = time_now
          @expiration = @time + expiration * 1_000_000_000
          @delay = delay
        end

        # Add an action to the transaction
        #
        # @param contract_id [String] a Contract's ID
        # @param action_name [String] the name of an action
        # @param action_data [any] args to the action
        def add_action(contract_id:, action_name:, action_data:)
          @actions << IOSTSdk::Models::Action.new.populate(
            model_data: {
              'contract' => contract_id,
              'action_name' => action_name.to_s,
              'data' => JSON.generate(action_data)
            }
          )
        end

        # Add an amount limit to the transaction
        #
        # @param token [String] name of the token
        # @param amount [Integer|String] amount of the token or 'unlimited'
        def add_approve(token:, amount:)
          @amount_limit << IOSTSdk::Models::AmountLimit.new.populate(
            model_data: {
              'token' => token.to_s,
              'value' => amount.to_s
            }
          )
        end
      end
    end
  end
end
