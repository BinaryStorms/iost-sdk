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

      def raw_data
        [contract, action_name, JSON.generate(data)]
      end
    end
  end
end
