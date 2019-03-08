# frozen_string_literal: true

module IOSTSdk
  module Http
    class GetNodeInfo
      require 'iost_sdk/models/node_info'

      def invoke(base_url:)
        resp = HTTParty.get("#{base_url}/getNodeInfo")
        raise HttpRequestError.new(status_code: resp.code, body: resp.body) unless
          resp.code == 200

        IOSTSdk::Models::NodeInfo.new.populate(model_data: JSON.parse(resp.body))
      end
    end
  end
end
