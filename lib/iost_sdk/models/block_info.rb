# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/block'

module IOSTSdk
  module Models
    class BlockInfo
      include Models

      def self.attr_names
        [
          'status',
          'block'
        ]
      end
    end
  end
end
