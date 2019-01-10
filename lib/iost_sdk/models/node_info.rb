# frozen_string_literal: true

require 'iost_sdk/models'

module IostSdk
  module Models
    class NodeInfo
      include Models

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
