# frozen_string_literal: true

require 'iost_sdk/models'
require 'iost_sdk/models/peer_info'

module IOSTSdk
  module Models
    class NetworkInfo
      include Models

      def self.attr_names
        [
          'id',
          'peer_count',
          'peer_info'
        ]
      end
    end
  end
end
