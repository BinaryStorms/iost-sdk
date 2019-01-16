module IOSTSdk
  module Http
    class GetGasRatio
      require 'iost_sdk/models/gas_ratio'

      def invoke(base_url:)
        resp = HTTParty.get("#{base_url}/getGasRatio")
        raise HttpRequestError.new(status_code: resp.code, body: resp.body) unless resp.code == 200
        IOSTSdk::Models::GasRatio.new.populate(model_data: JSON.parse(resp.body))
      end
    end
  end
end
