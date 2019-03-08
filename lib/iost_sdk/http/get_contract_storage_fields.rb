# frozen_string_literal: true

require 'json'
require 'iost_sdk/models/query/contract_storage_fields'

module IOSTSdk
  module Http
    class GetContractStorageFields
      def invoke(base_url:, query:)
        raise ArgumentError.new('query must be an instance of IOSTSdk::Models::Query::ContractStorageFields') unless
          query.is_a?(IOSTSdk::Models::Query::ContractStorageFields)

        resp = HTTParty.post(
          "#{base_url}/getContractStorageFields",
          body: JSON.generate(query.raw_data),
          headers: { 'Content-Type' => 'application/json' }
        )
        raise HttpRequestError.new(status_code: resp.code, body: resp.body) unless
          resp.code == 200

        { fields: JSON.parse(resp.body)['fields'] }
      end
    end
  end
end
