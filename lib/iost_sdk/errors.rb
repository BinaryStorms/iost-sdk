module IOSTSdk
  module Errors
    class InvalidModelDataError < StandardError
      def initialize(class_name, expected, actual)
        @message = "Model data for #{class_name} is invalid. Expecting attribute names: #{expected}, actual: #{actual}"
        super(@message)
      end
    end

    class InvalidTransactionError < StandardError
      def initialize(message)
        super(message)
      end
    end
  end
end
