# frozen_string_literal: true

module IOSTSdk
  module Models
    MODEL_REGISTRY = {
      'IOSTSdk::Models::NodeInfo' => {
        'network' => 'IOSTSdk::Models::NetworkInfo'
      },
      'IOSTSdk::Models::NetworkInfo' => {
        'peer_info' => 'IOSTSdk::Models::PeerInfo'
      },
      'IOSTSdk::Models::PeerInfo' => {},
      'IOSTSdk::Models::ChainInfo' => {},
      'IOSTSdk::Models::GasRatio' => {},
      'IOSTSdk::Models::RAMInfo' => {},
      'IOSTSdk::Models::Action' => {},
      'IOSTSdk::Models::AmountLimit' => {},
      'IOSTSdk::Models::Receipt' => {},
      'IOSTSdk::Models::TxReceipt' => {
        'receipts' => 'IOSTSdk::Models::Receipt'
      },
      'IOSTSdk::Models::Transaction' => {
        'actions' => 'IOSTSdk::Models::Action',
        'amount_limit' => 'IOSTSdk::Models::AmountLimit',
        'tx_receipt' => 'IOSTSdk::Models::TxReceipt'
      },
      'IOSTSdk::Models::TransactionInfo' => {
        'transaction' => 'IOSTSdk::Models::Transaction'
      },
      'IOSTSdk::Models::Block' => {
        'transactions' => 'IOSTSdk::Models::Transaction',
        'info' => 'IOSTSdk::Models::Info'
      },
      'IOSTSdk::Models::BlockInfo' => {
        'block' => 'IOSTSdk::Models::Block'
      }
    }.freeze

    def self.included base
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module ClassMethods
    end

    module InstanceMethods
      require 'iost_sdk/errors'

      # Creates an instance of a model from the JSON string.
      #
      # @param model_data [Hash] the JSON string of the model data
      # @return an instance of +model_class+ if +model_data+ is valid.
      def populate(model_data:)
        # if nil, short-curcuit
        return nil unless model_data

        # the model class is expected implement "attr_names" method
        model_attr_names = self.class.attr_names || []
        unless Set.new(model_attr_names).subset?(Set.new(model_data.keys))
          raise IOSTSdk::Errors::InvalidModelDataError.new(
            self.class.name,
            model_attr_names,
            model_data.keys
          )
        end
        # create the model
        model_data.each do |k, v|
          model_data_value = if IOSTSdk::Models::MODEL_REGISTRY[self.class.name].has_key?(k)
                               class_name = IOSTSdk::Models::MODEL_REGISTRY[self.class.name][k]
                               clazz = class_name.split('::').inject(Object) { |o, c| o.const_get c }

                               if v.is_a?(Hash)
                                 clazz.new.populate(model_data: v)
                               elsif v.is_a?(Array) # assume it's an Array
                                 v.map { |item| clazz.new.populate(model_data: item) }
                               end
                             else
                               v
                             end
          # set the instance var
          instance_variable_set("@#{k}", model_data_value)
          # define the attr_reader
          self.class.send(:define_method, k.to_sym) do
            instance_variable_get("@#{k}")
          end
        end

        self
      end
    end
  end
end
