module EksaMination
  module Formatters
    class Base
      COLORS = {
        green: "\e[32m",
        red: "\e[31m",
        yellow: "\e[33m",
        cyan: "\e[36m",
        reset: "\e[0m",
        bold: "\e[1m"
      }

      attr_reader :failures, :skipped, :example_count, :results
      attr_accessor :use_color

      def initialize
        @failures = []
        @skipped = []
        @results = []
        @example_count = 0
        @use_color = true
      end

      def group_started(group); end
      def group_finished(group); end

      def report_success(example)
        @example_count += 1
        @results << { example: example, status: :passed }
      end

      def report_failure(example, error)
        @example_count += 1
        @failures << { example: example, error: error }
        @results << { example: example, status: :failed, error: error }
      end

      def report_skipped(example)
        @example_count += 1
        @skipped << example
        @results << { example: example, status: :pending }
      end

      def summarize
        puts "\n\n"
        if @failures.any?
          puts colorize("Failures:", :red)
          @failures.each_with_index do |failure, i|
            example = failure[:example]
            error = failure[:error]
            puts "\n#{i + 1}) #{example.full_description}"
            if error.respond_to?(:expected) && (error.expected || error.actual)
              puts "   Failure/Error: #{colorize(error.failure_message, :red)} #{colorize(error.expected.inspect, :green)} (expected) vs #{colorize(error.actual.inspect, :red)} (actual)"
            else
              puts "   #{colorize(error.message, :red)}"
            end
            # Show file:line from backtrace
            bt = error.backtrace.find { |l| l.include?('_spec.rb') } || error.backtrace.first
            puts "   # #{bt}"
          end
        end

        puts "\n"
        color = @failures.any? ? :red : :green
        summary = "#{@example_count} examples, #{@failures.size} failures"
        summary += ", #{@skipped.size} pending" if @skipped.any?
        puts colorize(summary, color)
      end

      private

      def colorize(text, color)
        return text unless @use_color
        "#{COLORS[color]}#{text}#{COLORS[:reset]}"
      end
    end
  end
end
