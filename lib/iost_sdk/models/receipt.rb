# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class Receipt
      include Models

      def self.attr_names
        [
          'func_name',
          'content'
        ]
      end
    end
  end
end
