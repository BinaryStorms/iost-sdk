# frozen_string_literal: true

module IOSTSdk
  module Models
    MODEL_REGISTRY = {
      'IOSTSdk::Models::NodeInfo' => {
        'network' => {
          mode: :object,
          class: 'IOSTSdk::Models::NetworkInfo'
        }
      },
      'IOSTSdk::Models::NetworkInfo' => {
        'peer_info' => {
          mode: :list,
          class: 'IOSTSdk::Models::PeerInfo'
        }
      },
      'IOSTSdk::Models::PeerInfo' => {},
      'IOSTSdk::Models::ChainInfo' => {},
      'IOSTSdk::Models::GasRatio' => {},
      'IOSTSdk::Models::RAMInfo' => {},
      'IOSTSdk::Models::Action' => {},
      'IOSTSdk::Models::AmountLimit' => {},
      'IOSTSdk::Models::Receipt' => {},
      'IOSTSdk::Models::TxReceipt' => {
        'receipts' => {
          mode: :list,
          class: 'IOSTSdk::Models::Receipt'
        }
      },
      'IOSTSdk::Models::Transaction' => {
        'actions' => {
          mode: :list,
          class: 'IOSTSdk::Models::Action'
        },
        'amount_limit' => {
          mode: :list,
          class: 'IOSTSdk::Models::AmountLimit'
        },
        'tx_receipt' => {
          mode: :object,
          class: 'IOSTSdk::Models::TxReceipt'
        }
      },
      'IOSTSdk::Models::TransactionInfo' => {
        'transaction' => {
          mode: :object,
          class: 'IOSTSdk::Models::Transaction'
        }
      },
      'IOSTSdk::Models::Block' => {
        'transactions' => {
          mode: :list,
          class: 'IOSTSdk::Models::Transaction'
        },
        'info' => {
          mode: :object,
          class: 'IOSTSdk::Models::Info'
        }
      },
      'IOSTSdk::Models::BlockInfo' => {
        'block' => {
          mode: :object,
          class: 'IOSTSdk::Models::Block'
        }
      },
      'IOSTSdk::Models::AccountRAMInfo' => {},
      'IOSTSdk::Models::FrozenBalance' => {},
      'IOSTSdk::Models::PledgeInfo' => {},
      'IOSTSdk::Models::GasInfo' => {
        'pledged_info' => {
          mode: :list,
          class: 'IOSTSdk::Models::PledgeInfo'
        }
      },
      'IOSTSdk::Models::PermissionItem' => {},
      'IOSTSdk::Models::PermissionGroup' => {
        'items' => {
          mode: :list,
          class: 'IOSTSdk::Models::PermissionItem'
        }
      },
      'IOSTSdk::Models::Permission' => {
        'items' => {
          mode: :list,
          class: 'IOSTSdk::Models::PermissionItem'
        }
      },
      'IOSTSdk::Models::Account' => {
        'gas_info' => {
          mode: :object,
          class: 'IOSTSdk::Models::GasInfo'
        },
        'ram_info' => {
          mode: :object,
          class: 'IOSTSdk::Models::AccountRAMInfo'
        },
        'permissions' => {
          mode: :hash,
          class: 'IOSTSdk::Models::Permission'
        },
        'groups' => {
          mode: :hash,
          class: 'IOSTSdk::Models::PermissionGroup'
        },
        'frozen_balances' => {
          mode: :list,
          class: 'IOSTSdk::Models::FrozenBalance'
        }
      },
      'IOSTSdk::Models::TokenBalance' => {
        'frozen_balances' => {
          mode: :list,
          class: 'IOSTSdk::Models::FrozenBalance'
        }
      },
      'IOSTSdk::Models::ABI' => {
        'amount_limit' => {
          mode: :list,
          class: 'IOSTSdk::Models::AmountLimit'
        }
      },
      'IOSTSdk::Models::Contract' => {
        'abis' => {
          mode: :list,
          class: 'IOSTSdk::Models::ABI'
        }
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
        # proceed ONLY if actual data has a subset of keys of what's defined by the class
        unless Set.new(model_data.keys).subset?(Set.new(model_attr_names))
          raise IOSTSdk::Errors::InvalidModelDataError.new(
            self.class.name,
            model_attr_names,
            model_data.keys
          )
        end
        # create the model
        model_attr_names.each do |k|
          v = model_data[k]
          # set the instance var
          instance_variable_set("@#{k}", parse(data_key: k, data_value: v))
          # define the attr_reader
          self.class.send(:define_method, k.to_sym) do
            instance_variable_get("@#{k}")
          end
        end

        self
      end
    end

    def parse(data_key:, data_value:)
      # if nil, short-curcuit
      return nil unless data_value

      if IOSTSdk::Models::MODEL_REGISTRY[self.class.name].has_key?(data_key)
        instruction = IOSTSdk::Models::MODEL_REGISTRY[self.class.name][data_key]
        mode = instruction[:mode]
        class_name = instruction[:class]
        clazz = class_name.split('::').inject(Object) { |o, c| o.const_get c }

        case mode
        when :object
          clazz.new.populate(model_data: data_value)
        when :list
          data_value.empty? ? [] : data_value.map { |item| clazz.new.populate(model_data: item) }
        when :hash
          if data_value.empty?
            {}
          else
            data_value.inject({}) do |memo, (v_key, v_value)|
              memo[v_key] = clazz.new.populate(model_data: v_value)
              memo
            end
          end
        end
      else
        data_value
      end
    end
  end
end
