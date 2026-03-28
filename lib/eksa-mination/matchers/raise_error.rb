module EksaMination
  module Matchers
    class RaiseErrorMatcher
      attr_reader :expected, :expected_message

      def initialize(error_class, expected_message)
        @expected = error_class
        @expected_message = expected_message
        @actual_error = nil
      end

      def matches?(block)
        return false unless block.respond_to?(:call)
        begin
          block.call
          false
        rescue @expected => e
          @actual_error = e
          @expected_message ? (e.message == @expected_message) : true
        rescue => e
          @actual_error = e
          false
        end
      end

      def failure_message
        @actual_error ? "raised #{@actual_error.class} (#{@actual_error.message}) instead of #{@expected}" : "did not raise #{@expected}"
      end

      def negative_failure_message
        "raised #{@expected}"
      end
    end
  end
end
