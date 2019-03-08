# frozen_string_literal: true

require 'json'
require 'iost_sdk/models/query/signed_transaction'

module IOSTSdk
  module Http
    class SendTx
      def invoke(base_url:, transaction:, account_name:, key_pair:)
        # sign the transaction first
        signed_txn = IOSTSdk::Models::Query::SignedTransaction.from_transaction(transaction: transaction)
        final_txn = signed_txn.sign(account_name: account_name, key_pair: key_pair)

        resp = HTTParty.post(
          "#{base_url}/sendTx",
          body: JSON.generate(final_txn.raw_data),
          headers: { 'Content-Type' => 'application/json' }
        )
        raise HttpRequestError.new(status_code: resp.code, body: resp.body) unless
          resp.code == 200

        JSON.parse(resp.body)
      end
    end
  end
end
