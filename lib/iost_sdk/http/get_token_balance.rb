module IOSTSdk
  module Http
    class GetTokenBalance
      require 'iost_sdk/models/token_balance'

      def invoke(base_url:, account_name:, token_name:, by_longest_chain:)
        resp = HTTParty.get("#{base_url}/getTokenBalance/#{account_name}/#{token_name}/#{by_longest_chain}")
        raise HttpRequestError.new(status_code: resp.code, body: resp.body) unless resp.code == 200
        IOSTSdk::Models::TokenBalance.new.populate(model_data: JSON.parse(resp.body))
      end
    end
  end
end
