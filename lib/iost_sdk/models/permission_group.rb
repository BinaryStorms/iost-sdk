# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class PermissionGroup
      include Models

      require 'iost_sdk/models/permission_item'

      def self.attr_names
        [
          'name',
          'items'
        ]
      end
    end
  end
end
