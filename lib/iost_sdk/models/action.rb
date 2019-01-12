# frozen_string_literal: true

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
    end
  end
end
