module IOSTSdk
  module Http
    class GetTxByHash
      require 'iost_sdk/models/transaction_info'

      def invoke(base_url:, hash_value:)
        resp = HTTParty.get("#{base_url}/getTxByHash/#{hash_value}")
        raise HttpRequestError.new(status_code: resp.code, body: resp.body) unless resp.code == 200
        IOSTSdk::Models::TransactionInfo.new.populate(model_data: JSON.parse(resp.body))
      end
    end
  end
end
