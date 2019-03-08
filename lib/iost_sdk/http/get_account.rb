# frozen_string_literal: true

module IOSTSdk
  module Http
    class GetAccount
      require 'iost_sdk/models/account'

      def invoke(base_url:, name:, by_longest_chain:)
        resp = HTTParty.get("#{base_url}/getAccount/#{name}/#{by_longest_chain}")
        raise HttpRequestError.new(status_code: resp.code, body: resp.body) unless
          resp.code == 200

        IOSTSdk::Models::Account.new.populate(model_data: JSON.parse(resp.body))
      end
    end
  end
end
