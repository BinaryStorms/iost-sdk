# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class Permission
      include Models

      def self.attr_names
        [
          'name',
          'groups',
          'items',
          'threshold'
        ]
      end
    end
  end
end
