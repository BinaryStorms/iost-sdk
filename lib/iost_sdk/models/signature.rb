# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class Signature
      include Models

      def self.attr_names
        [
          'algorithm',
          'public_key',
          'signature'
        ]
      end
    end
  end
end
