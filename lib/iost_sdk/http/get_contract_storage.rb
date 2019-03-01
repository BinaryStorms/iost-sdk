# frozen_string_literal: true

require 'json'
require 'iost_sdk/models/query/contract_storage'

module IOSTSdk
  module Http
    class GetContractStorage
      def invoke(base_url:, query:)
        raise ArgumentError.new('query must be an instance of IOSTSdk::Models::Query::ContractStorage') unless
          query.is_a?(IOSTSdk::Models::Query::ContractStorage)

        resp = HTTParty.post(
          "#{base_url}/getContractStorage",
          body: JSON.generate(query.raw_data),
          headers: { 'Content-Type' => 'application/json' }
        )
        raise HttpRequestError.new(status_code: resp.code, body: resp.body) unless
          resp.code == 200

        { data: JSON.parse(resp.body)['data'] }
      end
    end
  end
end
