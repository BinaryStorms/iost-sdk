module IOSTSdk
  module Http
    class GetContractStorageFields
      require 'iost_sdk/models/query/contract_storage_fields'

      def invoke(base_url:, query:)
        raise ArgumentError.new('query must be an instance of IOSTSdk::Models::Query::ContractStorageFields') unless query.is_a?(IOSTSdk::Models::Query::ContractStorageFields)

        query_data = query.instance_variables
                          .reduce({}) do |memo, var_name|
                            n = var_name.to_s[1..-1].to_sym
                            memo[n] = query.send(n)
                            memo
                          end

        resp = HTTParty.post(
          "#{base_url}/getContractStorageFields",
          body: JSON.generate(query_data),
          headers: { 'Content-Type' => 'application/json' }
        )
        raise HttpRequestError.new(status_code: resp.code, body: resp.body) unless resp.code == 200
        { fields: JSON.parse(resp.body)['fields'] }
      end
    end
  end
end
