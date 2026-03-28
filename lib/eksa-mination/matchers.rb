require_relative 'matchers/eq'
require_relative 'matchers/be'
require_relative 'matchers/match'
require_relative 'matchers/include'
require_relative 'matchers/raise_error'
require_relative 'matchers/truthy'
require_relative 'matchers/falsey'
require_relative 'matchers/be_a'
require_relative 'matchers/respond_to'

module EksaMination
  module Expectations
    def expect(actual = nil, &block)
      Expectation.new(actual || block)
    end
  end

  class Expectation
    def initialize(actual)
      @actual = actual
    end

    def to(matcher)
      # Some matchers (like raise_error) need the block itself
      if matcher.matches?(@actual)
        # Success
      else
        expected = matcher.respond_to?(:expected) ? matcher.expected : nil
        raise MatchError.new(
          "Expected: #{expected.inspect}\nActual:   #{@actual.inspect}",
          matcher.failure_message,
          expected,
          @actual
        )
      end
    end

    def not_to(matcher)
      if matcher.matches?(@actual)
        raise MatchError.new("Expected: not to be #{matcher.expected.inspect}\nActual:   #{@actual.inspect}", matcher.negative_failure_message)
      end
    end
  end

  class MatchError < StandardError
    attr_reader :detail, :failure_message, :expected, :actual

    def initialize(detail, failure_message = nil, expected = nil, actual = nil)
      @detail = detail
      @failure_message = failure_message
      @expected = expected
      @actual = actual
      super(detail)
    end
  end

  module Matchers
    def eq(expected)
      EqMatcher.new(expected)
    end

    def be(expected)
      BeMatcher.new(expected)
    end

    def match(regex)
      MatchMatcher.new(regex)
    end

    def include(expected)
      IncludeMatcher.new(expected)
    end

    def raise_error(error_class = StandardError, message = nil)
      RaiseErrorMatcher.new(error_class, message)
    end

    def be_a(klass)
      BeAMatcher.new(klass)
    end

    def respond_to(method)
      RespondToMatcher.new(method)
    end

    def be_nil
      be(nil)
    end

    def be_truthy
      TruthyMatcher.new
    end

    def be_falsey
      FalseyMatcher.new
    end
  end
end

# Global monkeypatch
Object.include(EksaMination::Expectations)
Object.include(EksaMination::Matchers)
