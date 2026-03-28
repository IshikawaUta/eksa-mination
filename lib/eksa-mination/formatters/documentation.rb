require_relative 'base'

module EksaMination
  module Formatters
    class Documentation < Base
      def initialize
        super
        @level = 0
      end

      def group_started(group)
        puts "  " * @level + group.description
        @level += 1
      end

      def group_finished(group)
        @level -= 1
      end

      def report_success(example)
        super
        puts "  " * @level + colorize(example.description, :green)
      end

      def report_failure(example, error)
        super
        puts "  " * @level + colorize(example.description + " (FAILED)", :red)
      end

      def report_skipped(example)
        super
        puts "  " * @level + colorize(example.description + " (PENDING)", :yellow)
      end
    end
  end
end
