# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class VoteInfo
      include Models

      def self.attr_names
        [
          'option',
          'votes',
          'cleared_votes'
        ]
      end
    end
  end
end
