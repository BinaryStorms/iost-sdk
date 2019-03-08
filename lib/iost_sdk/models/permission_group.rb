# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/permission_item'

module IOSTSdk
  module Models
    class PermissionGroup
      include Models

      def self.attr_names
        [
          'name',
          'items'
        ]
      end
    end
  end
end
