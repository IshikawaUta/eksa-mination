module EksaMination
  module Mocks
    def allow(object)
      Proxy.new(object)
    end

    def double(name = "Double")
      Object.new.tap do |obj|
        obj.define_singleton_method(:to_s) { name }
        obj.define_singleton_method(:inspect) { "#<Double:#{name}>" }
      end
    end

    def stub_const(const_name, value)
      stub = ConstantStub.new(const_name, value)
      stub.apply
      EksaMination::Mocks.register_stub(stub)
    end

    def self.reset
      @stubs ||= []
      @stubs.each(&:restore)
      @stubs = []
    end

    def self.register_stub(stub)
      @stubs ||= []
      @stubs << stub
    end

    class Proxy
      def initialize(object)
        @object = object
      end

      def to(matcher)
        matcher.set_object(@object)
        matcher
      end
    end

    class ReceiveMatcher
      def initialize(method_name)
        @method_name = method_name
        @return_value = nil
        @object = nil
      end

      def set_object(object)
        @object = object
        apply_stub
      end

      def and_return(value)
        @return_value = value
        apply_stub if @object
        self
      end

      private

      def apply_stub
        stub = Stub.new(@object, @method_name, @return_value)
        stub.apply
        EksaMination::Mocks.register_stub(stub)
      end
    end

    class Stub
      def initialize(object, method_name, return_value)
        @object = object
        @method_name = method_name
        @return_value = return_value
        @original_method = nil
      end

      def apply
        @original_method = @object.method(@method_name) if @object.respond_to?(@method_name)
        
        return_val = @return_value
        
        @object.define_singleton_method(@method_name) do |*args, &block|
          return_val
        end
      end

      def restore
        if @original_method
          @object.define_singleton_method(@method_name, &@original_method)
        else
          @object.singleton_class.remove_method(@method_name) rescue nil
        end
      end
    end

    class ConstantStub
      def initialize(name, value)
        @name = name
        @value = value
        @original_value = nil
        @defined = false
      end

      def apply
        parts = @name.split('::')
        @const_name = parts.pop
        @parent = parts.empty? ? Object : Object.const_get(parts.join('::'))

        if @parent.const_defined?(@const_name, false)
          @original_value = @parent.const_get(@const_name, false)
          @defined = true
          @parent.send(:remove_const, @const_name)
        end

        @parent.const_set(@const_name, @value)
      end

      def restore
        @parent.send(:remove_const, @const_name) rescue nil
        @parent.const_set(@const_name, @original_value) if @defined
      end
    end
  end

  def self.reset_mocks
    Mocks.reset
  end
end

module EksaMination::Matchers
  def receive(method_name)
    EksaMination::Mocks::ReceiveMatcher.new(method_name)
  end
end

# Global monkeypatch
Object.include(EksaMination::Mocks)
