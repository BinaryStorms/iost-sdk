module IOSTSdk
  module Http
    class GetRamInfo
      require 'iost_sdk/models/ram_info'

      def invoke(base_url:)
        resp = HTTParty.get("#{base_url}/getRAMInfo")
        raise HttpRequestError.new(status_code: resp.code, body: resp.body) unless resp.code == 200
        IOSTSdk::Models::RAMInfo.new.populate(model_data: JSON.parse(resp.body))
      end
    end
  end
end
