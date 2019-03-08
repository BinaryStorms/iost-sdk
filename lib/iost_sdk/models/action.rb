# frozen_string_literal: true

require 'json'
require 'iost_sdk/models'

module IOSTSdk
  module Models
    class Action
      include Models

      def self.attr_names
        [
          'contract',
          'action_name',
          'data'
        ]
      end

      def raw_data_bytes
        [contract, action_name, data.to_s]
      end
    end
  end
end
