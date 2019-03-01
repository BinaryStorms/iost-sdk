# frozen_string_literal: true

module IOSTSdk
  module Http
    class GetContract
      require 'iost_sdk/models/contract'

      def invoke(base_url:, id:, by_longest_chain:)
        resp = HTTParty.get("#{base_url}/getContract/#{id}/#{by_longest_chain}")
        raise HttpRequestError.new(status_code: resp.code, body: resp.body) unless
          resp.code == 200

        IOSTSdk::Models::Contract.new.populate(model_data: JSON.parse(resp.body))
      end
    end
  end
end
