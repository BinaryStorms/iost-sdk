# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class PermissionItem
      include Models

      def self.attr_names
        [
          'id',
          'is_key_pair',
          'weight',
          'permission'
        ]
      end
    end
  end
end
