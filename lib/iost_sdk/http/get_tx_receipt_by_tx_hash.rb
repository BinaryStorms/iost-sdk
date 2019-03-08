# frozen_string_literal: true

module IOSTSdk
  module Http
    class GetTxReceiptByTxHash
      require 'iost_sdk/models/tx_receipt'

      def invoke(base_url:, hash_value:)
        resp = HTTParty.get("#{base_url}/getTxReceiptByTxHash/#{hash_value}")
        raise HttpRequestError.new(status_code: resp.code, body: resp.body) unless
          resp.code == 200

        IOSTSdk::Models::TxReceipt.new.populate(model_data: JSON.parse(resp.body))
      end
    end
  end
end
