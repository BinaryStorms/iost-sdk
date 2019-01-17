module IOSTSdk
  module Http
    class GetContractStorage
      require 'iost_sdk/models/query/contract_storage_query'

      def invoke(base_url:, query:)
        raise ArgumentError.new('query must be an instance of IOSTSdk::Models::Query::ContractStorageQuery') unless query.is_a?(IOSTSdk::Models::Query::ContractStorageQuery)

        query_data = query.instance_variables
                          .each_with_object({}) do |var_name, memo|
                            n = var_name.to_s[1..-1].to_sym
                            memo[n] = query.send(n)
                          end

        resp = HTTParty.post(
          "#{base_url}/getContractStorage",
          body: JSON.generate(query_data),
          headers: { 'Content-Type' => 'application/json' }
        )
        raise HttpRequestError.new(status_code: resp.code, body: resp.body) unless resp.code == 200
        { data: JSON.parse(resp.body)['data'] }
      end
    end
  end
end
