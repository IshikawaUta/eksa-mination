module EksaMination
  class Runner
    def initialize(groups, reporter, options = {})
      @groups = groups
      @reporter = reporter
      @options = options
    end

    def run
      @groups.each do |group|
        run_group(group)
      end
      @reporter.summarize
    end

    private

    def run_group(group)
      @reporter.group_started(group)
      begin
        group.examples.each do |example|
          if example.is_a?(ExampleGroup)
            run_group(example) # Recursive for nested groups
          elsif group.skipped || example.skipped
            @reporter.report_skipped(example)
          else
            next unless should_run?(example)
            run_example(group, example)
          end
        end
      ensure
        @reporter.group_finished(group)
      end
    end

    def should_run?(example)
      # Match tag filter if provided
      if @options[:tag]
        tag_key = @options[:tag].to_sym
        return false unless example.metadata[tag_key]
      end

      # Match name filter if provided
      if @options[:example]
        return false unless example.full_description.include?(@options[:example])
      end

      # Match line number filter if provided for this file
      if @options[:line_numbers] && @options[:line_numbers][example.file_path]
        return false unless @options[:line_numbers][example.file_path].include?(example.line_number)
      end

      true
    end

    def run_example(group, example)
      # Create an instance to run the hooks and example in
      context = Object.new
      context.extend(EksaMination::Expectations)
      context.extend(EksaMination::Matchers)
      context.extend(EksaMination::Mocks)

      # Collect all let/subject/hooks from hierarchy
      hierarchy = []
      current = group
      while current
        hierarchy.unshift(current)
        current = current.parent
      end

      # Handle let, let!, and subject
      cache = {}
      
      hierarchy.each do |g|
        # Define let methods from this group
        g.let_blocks.each do |name, block|
          context.define_singleton_method(name) do
            cache[name] ||= context.instance_eval(&block)
          end
        end

        # Define let! methods from this group (eagerly evaluated)
        g.let_bang_blocks.each do |name, block|
          context.define_singleton_method(name) do
            cache[name] ||= context.instance_eval(&block)
          end
          # Trigger early
          context.send(name)
        end

        # Define subject if present in this group
        if g.subject_block
          context.define_singleton_method(:subject) do
            cache[:subject] ||= context.instance_eval(&g.subject_block)
          end
        end
      end

      begin
        # Run before hooks from outside-in
        hierarchy.each do |g|
          g.before_hooks.each { |hook| context.instance_eval(&hook) }
        end
        
        # Execute the test
        context.instance_eval(&example.block)
        @reporter.report_success(example)
      rescue => e
        @reporter.report_failure(example, e)
      ensure
        # Run after hooks from inside-out
        hierarchy.reverse_each do |g|
          g.after_hooks.each { |hook| context.instance_eval(&hook) }
        end
        # Cleanup stubs if we had any
        EksaMination.reset_mocks if EksaMination.respond_to?(:reset_mocks)
      end
    end
  end
end
