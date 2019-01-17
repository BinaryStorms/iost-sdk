module IOSTSdk
  module Http
    class GetBlockByNumber
      require 'iost_sdk/models/block_info'

      def invoke(base_url:, number:, complete:)
        resp = HTTParty.get("#{base_url}/getBlockByNumber/#{number}/#{complete}")
        raise HttpRequestError.new(status_code: resp.code, body: resp.body) unless resp.code == 200
        IOSTSdk::Models::BlockInfo.new.populate(model_data: JSON.parse(resp.body))
      end
    end
  end
end
