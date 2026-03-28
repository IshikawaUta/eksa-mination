module EksaMination
  module DSL
    def describe(description, *metadata, &block)
      # Check if we are inside another describe
      parent = EksaMination.current_group
      file_path, line_number = block.source_location
      options = process_metadata(metadata)
      group = ExampleGroup.new(description, parent: parent, metadata: options, file_path: file_path, line_number: line_number)
      
      EksaMination.current_group = group
      group.instance_eval(&block)
      EksaMination.current_group = parent
      
      # Only register top-level groups to the main runner
      EksaMination.register_group(group) unless parent
    end

    def xdescribe(description, *metadata, &block)
      file_path, line_number = block.source_location
      options = process_metadata(metadata).merge(skipped: true)
      group = ExampleGroup.new(description, parent: EksaMination.current_group, metadata: options, skipped: true, file_path: file_path, line_number: line_number)
      EksaMination.register_group(group)
    end

    def shared_examples(name, &block)
      EksaMination.shared_examples[name] = block
    end

    private

    def process_metadata(metadata_args)
      options = {}
      metadata_args.each do |arg|
        if arg.is_a?(Symbol)
          options[arg] = true
        elsif arg.is_a?(Hash)
          options.merge!(arg)
        end
      end
      options
    end
  end

  class ExampleGroup
    attr_reader :description, :examples, :before_hooks, :after_hooks, :let_blocks, :let_bang_blocks, :subject_block, :skipped, :parent, :file_path, :line_number, :metadata

    def initialize(description, parent: nil, skipped: false, metadata: {}, file_path: nil, line_number: nil)
      @description = description
      @parent = parent
      @examples = []
      @before_hooks = []
      @after_hooks = []
      @let_blocks = {}
      @let_bang_blocks = {}
      @skipped = skipped || (parent && parent.skipped)
      @metadata = (parent ? parent.metadata.merge(metadata) : metadata)
      @file_path = file_path
      @line_number = line_number
    end

    def it(description, *metadata, &block)
      file_path, line_number = block.source_location
      options = process_metadata(metadata)
      @examples << Example.new(description, block, parent: self, metadata: options, file_path: file_path, line_number: line_number)
    end

    def xit(description, *metadata, &block)
      file_path, line_number = block.source_location
      options = process_metadata(metadata).merge(skipped: true)
      @examples << Example.new(description, block, parent: self, metadata: options, skipped: true, file_path: file_path, line_number: line_number)
    end


    def let(name, &block)
      @let_blocks[name] = block
    end

    def let!(name, &block)
      @let_bang_blocks[name] = block
    end

    def subject(&block)
      @subject_block = block
    end

    def before(&block)
      @before_hooks << block
    end

    def after(&block)
      @after_hooks << block
    end

    def full_description
      @parent ? "#{@parent.full_description} #{@description}" : @description
    end
    
    # Nested groups started from inside this group
    def describe(description, &block)
      file_path, line_number = block.source_location
      group = ExampleGroup.new(description, parent: self, file_path: file_path, line_number: line_number)
      @examples << group
      group.instance_eval(&block)
    end

    def it_behaves_like(name, *args)
      block = EksaMination.shared_examples[name]
      raise "Shared examples '#{name}' not found" unless block
      instance_exec(*args, &block)
    end

    private

    def process_metadata(metadata_args)
      options = {}
      metadata_args.each do |arg|
        if arg.is_a?(Symbol)
          options[arg] = true
        elsif arg.is_a?(Hash)
          options.merge!(arg)
        end
      end
      options
    end
  end

  class Example
    attr_reader :description, :block, :skipped, :file_path, :line_number, :parent, :metadata

    def initialize(description, block, parent: nil, metadata: {}, skipped: false, file_path: nil, line_number: nil)
      @description = description
      @block = block
      @parent = parent
      @metadata = (parent ? parent.metadata.merge(metadata) : metadata)
      @skipped = skipped || @metadata[:skipped]
      @file_path = file_path
      @line_number = line_number
    end

    def full_description
      @parent ? "#{@parent.full_description} #{@description}" : @description
    end
  end

  @groups = []
  @current_group = nil
  @shared_examples = {}

  def self.register_group(group)
    @groups << group
  end

  def self.groups
    @groups
  end

  def self.shared_examples
    @shared_examples
  end

  def self.current_group
    @current_group
  end

  def self.current_group=(group)
    @current_group = group
  end

  def self.reset!
    @groups = []
  end
end

# Global monkeypatch
Object.include(EksaMination::DSL)
