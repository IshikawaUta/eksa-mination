module EksaMination
  module Matchers
    class IncludeMatcher
      attr_reader :expected
      def initialize(expected); @expected = expected; end
      def matches?(actual); actual.include?(@expected); end
      def failure_message; "does not include"; end
      def negative_failure_message; "includes"; end
    end
  end
end
