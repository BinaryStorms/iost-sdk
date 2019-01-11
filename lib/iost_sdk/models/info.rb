# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class Info
      include Models

      def self.attr_names
        [
          'mode',
          'thread',
          'batch_index'
        ]
      end
    end
  end
end
