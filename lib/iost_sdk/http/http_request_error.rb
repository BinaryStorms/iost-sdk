module IOSTSdk
  module Http
    class HttpRequestError < StandardError
      def initialize(status_code:, body:)
        super("HTTP request error. Status code #{status_code}. Response body: #{body}")
      end
    end
  end
end
