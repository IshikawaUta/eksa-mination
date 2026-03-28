require 'json'
require_relative 'base'

module EksaMination
  module Formatters
    class JSONFormatter < Base
      def report_success(example); super; end
      def report_failure(example, error); super; end
      def report_skipped(example); super; end

      def summarize
        data = {
          version: EksaMination::VERSION,
          summary: {
            example_count: @example_count,
            failure_count: @failures.size,
            pending_count: @skipped.size
          },
          examples: @results.map do |res|
            example = res[:example]
            item = {
              description: example.description,
              full_description: example.full_description,
              status: res[:status].to_s,
              file_path: example.file_path,
              line_number: example.line_number
            }
            
            if res[:status] == :failed
              error = res[:error]
              item[:exception] = {
                class: error.class.name,
                message: error.message,
                backtrace: error.backtrace
              }
            end
            
            item
          end
        }
        puts JSON.pretty_generate(data)
      end
    end
  end
end
