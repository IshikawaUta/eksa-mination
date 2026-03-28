module EksaMination
  module Matchers
    class RespondToMatcher
      attr_reader :expected
      def initialize(expected); @expected = expected; end
      def matches?(actual); actual.respond_to?(@expected); end
      def failure_message; "does not respond to"; end
    end
  end
end
