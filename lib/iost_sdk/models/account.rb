# frozen_string_literal: true

require 'iost_sdk/models'

module IOSTSdk
  module Models
    class Account
      include Models

      require 'iost_sdk/models/permission'
      require 'iost_sdk/models/permission_group'
      require 'iost_sdk/models/permission_item'
      require 'iost_sdk/models/gas_info'
      require 'iost_sdk/models/account_ram_info'
      require 'iost_sdk/models/frozen_balance'
      require 'iost_sdk/models/vote_info'

      def self.attr_names
        [
          'name',
          'balance',
          'create_time',
          'gas_info',
          'ram_info',
          'permissions',
          'groups',
          'frozen_balances',
          'vote_infos'
        ]
      end
    end
  end
end
