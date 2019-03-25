# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class ChainInfo
      include Models

      def self.attr_names
        [
          'net_name',
          'protocol_version',
          'chain_id',
          'head_block',
          'head_block_hash',
          'lib_block',
          'lib_block_hash',
          'witness_list',
          'lib_witness_list',
          'pending_witness_list',
          'head_block_time',
          'lib_block_time'
        ]
      end
    end
  end
end
