# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class PeerInfo
      include Models

      def self.attr_names
        [
          'id',
          'addr'
        ]
      end
    end
  end
end
