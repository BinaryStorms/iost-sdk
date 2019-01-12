# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class NodeInfo
      include Models

      require 'iost_sdk/models/network_info'

      def self.attr_names
        [
          'build_time',
          'git_hash',
          'mode',
          'network'
        ]
      end
    end
  end
end
