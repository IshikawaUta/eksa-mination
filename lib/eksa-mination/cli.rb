require 'optparse'

module EksaMination
  class CLI
    def initialize(args)
      @args = load_config_args + args
      @options = {
        pattern: 'spec/**/*_spec.rb'
      }
    end

    def run
      parse_options
      files = discover_files
      
      if files.empty?
        puts "No spec files found."
        exit 1
      end

      files.each do |file|
        load File.expand_path(file)
      end

      if @options[:formatter]
        EksaMination.reporter = @options[:formatter].new
      end
      EksaMination.reporter.use_color = @options[:color] unless @options[:color].nil?
      EksaMination.run(@options)
      
      # Exit with status code based on failures
      exit(EksaMination.reporter.instance_variable_get(:@failures).any? ? 1 : 0)
    end

    private

    def load_config_args
      if File.exist?('.eksa-mination')
        File.read('.eksa-mination').split(/\s+/)
      else
        []
      end
    end

    def parse_options
      OptionParser.new do |opts|
        opts.banner = "Usage: eksa-mination [options] [files or directories]"
        opts.separator ""
        opts.separator "  **** Output ****"
        opts.separator ""
        
        opts.on("-v", "--version", "Display the version.") do
          puts "eksa-mination #{EksaMination::VERSION}"
          exit
        end

        opts.on("-h", "--help", "You're looking at it.") do
          puts opts
          exit
        end

        opts.on("-P", "--pattern PATTERN", "Load files matching pattern (default: \"spec/**/*_spec.rb\").") do |p|
          @options[:pattern] = p
        end

        opts.on("-f", "--format FORMATTER", "Choose a formatter ([p]rogress, [d]ocumentation, [j]son, [h]tml)") do |f|
          case f
          when 'p', 'progress'
            @options[:formatter] = EksaMination::Formatters::Progress
          when 'd', 'documentation'
            @options[:formatter] = EksaMination::Formatters::Documentation
          when 'j', 'json'
            @options[:formatter] = EksaMination::Formatters::JSONFormatter
          when 'h', 'html'
            @options[:formatter] = EksaMination::Formatters::HTML
          end
        end

        opts.on("--[no-]color", "--[no-]colour", "Enable/disable color output") do |c|
          # logic for color toggle can be added to BaseFormatter
          @options[:color] = c
        end

        opts.separator ""
        opts.separator "  **** Filtering/tags ****"
        opts.separator ""
        opts.on("-e", "--example STRING", "Run examples whose full nested names include STRING") do |s|
          @options[:example] = s
        end

        opts.on("-t", "--tag TAG", "Run examples with the specified tag") do |t|
          @options[:tag] = t
        end
      end.parse!(@args)
    end

    def discover_files
      if @args.empty?
        Dir.glob(@options[:pattern])
      else
        @args.flat_map do |arg|
          path, line = arg.split(':')
          if line
            @options[:line_numbers] ||= {}
            full_path = File.expand_path(path)
            @options[:line_numbers][full_path] ||= []
            @options[:line_numbers][full_path] << line.to_i
            path
          elsif File.directory?(path)
            Dir.glob(File.join(path, "**/*_spec.rb"))
          else
            path
          end
        end.compact.uniq
      end
    end
  end
end
