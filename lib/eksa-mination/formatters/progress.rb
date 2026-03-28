require_relative 'base'

module EksaMination
  module Formatters
    class Progress < Base
      def report_success(example)
        super
        print colorize(".", :green)
      end

      def report_failure(example, error)
        super
        print colorize("F", :red)
      end

      def report_skipped(example)
        super
        print colorize("*", :yellow)
      end
    end
  end
end
