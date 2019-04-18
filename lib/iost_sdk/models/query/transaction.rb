# frozen_string_literal: true

require 'json'
require 'iost_sdk/errors'
require 'iost_sdk/models'
require 'iost_sdk/models/amount_limit'
require 'iost_sdk/models/action'
require 'iost_sdk/models/signature'

module IOSTSdk
  module Models
    module Query
      class Transaction
        include Models

        GAS_LIMIT_RANGE = [6000, 4_000_000].freeze
        GAS_RATIO_RANGE = [1, 100].freeze
        NUMERIC_REGEX = /^\d+(\.\d+)?$/.freeze

        attr_accessor :chain_id

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
          raise IOSTSdk::Errors::InvalidTransactionError.new('approve token should not be *') if token == '*'
          raise IOSTSdk::Errors::InvalidTransactionError.new('approve amount should be numeric') unless amount.is_a?(Numeric)

          @amount_limit << IOSTSdk::Models::AmountLimit.new.populate(
            model_data: {
              'token' => token.to_s,
              'value' => amount.to_s
            }
          )
        end

        # Verify if the transaction object is valid
        def is_valid?
          [
            # check gas limit
            gas_limit.is_a?(Numeric) && gas_limit.between?(GAS_LIMIT_RANGE.first, GAS_LIMIT_RANGE.last),
            # check gas ratio
            gas_ratio.is_a?(Numeric) && gas_ratio.between?(GAS_RATIO_RANGE.first, GAS_RATIO_RANGE.last),
            # check approve token and amount
            amount_limit.all? { |al| al.token != '*' || /^\d+(\.\d+)?$/ =~ al.value }
          ].all?
        end
      end
    end
  end
end
