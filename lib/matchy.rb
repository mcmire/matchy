unless defined?(Test::Unit) || defined?(MiniTest)
  raise LoadError, "Matchy couldn't find a testing library! You must require Test::Unit or MiniTest before requiring matchy." 
end

# Matchy works with either Test::Unit or MiniTest, on both Ruby 1.8 and >= 1.9.1.
# Note that Ruby 1.9.0 is NOT supported... but you should really be using 1.9.1 ;)
module Matchy
  class Adapter < Struct.new(:name, :full_name)
    def on_use; end
  end
  
  @@adapters = {}
  @@current_adapter = nil
  
  class << self
    def adapter(adapter_name, full_name, &block)
      @@adapters[adapter_name.to_s] = Adapter.new(adapter_name, full_name).extend(Module.new(&block))
    end
    def use(adapter_name)
      adapter_name = adapter_name.to_s
      @@current_adapter = @@adapters[adapter_name] or raise "Couldn't find adapter by name '#{adapter_name}'"
      if ENV["MATCHY_DEBUG"] || $MATCHY_DEBUG
        msg = "\n"
        msg << " -- This is Ruby version #{RUBY_VERSION}, using #{@@current_adapter.full_name}"
        msg << " (MiniTest-Test::Unit shim)" if @@current_adapter.name == :minitest && Matchy.minitest_tu_shim?
        msg << "\n\n"
        print msg
      end
      @@current_adapter.on_use
      Matchy.init
    end
    def adapter_not_found_msg
      "Matchy detected you have a testing library loaded, but it doesn't have an adapter for it. Try these adapters: #{@@adapters.keys.sort.join(", ")}"
    end
  end
  
  adapter :minitest, "MiniTest" do
    def assertions_module; MiniTest::Assertions; end
    def test_case_class; MiniTest::Unit::TestCase; end
    def assertion_failed_error; MiniTest::Assertion; end
    def on_use; MiniTest::Unit.autorun; end
  end
  adapter :testunit, "Test::Unit" do
    def assertions_module; Test::Unit::Assertions; end
    def test_case_class; Test::Unit::TestCase; end
    def assertion_failed_error; Test::Unit::AssertionFailedError; end
  end
  
  #---
  
  class << self
    def minitest_tu_shim?
      defined?(MiniTest) && defined?(MiniTest::Assertions) &&
      defined?(Test::Unit::TestCase) && Test::Unit::TestCase < MiniTest::Assertions
    end
  
    def classic?
      defined?(Test::Unit) && defined?(Test::Unit::TestCase) && !minitest_tu_shim?
    end
  
    def minitest?
      # We have to decide if we really have a suite of MiniTest tests.
      # Rails for example defines MiniTest, so to only check for
      # defined?(MiniTest) would be malicious
      defined?(MiniTest) && !classic?
    end
    
    %w(assertions_module test_case_class assertion_failed_error).each do |method|
      define_method(method) do
        @@current_adapter ? @@current_adapter.__send__(method) : raise(LoadError, Matchy.adapter_not_found_msg)
      end
    end
  
    def init
      require 'matchy/assertions'
      require 'matchy/expectation_builder'
      require 'matchy/modals'
      require 'matchy/matcher_builder'
      require 'matchy/custom_matcher'
      require 'matchy/version'

      require 'matchy/built_in/enumerable_expectations'
      require 'matchy/built_in/error_expectations'
      require 'matchy/built_in/truth_expectations'
      require 'matchy/built_in/operator_expectations'
      require 'matchy/built_in/change_expectations'

      Matchy.test_case_class.class_eval do
        include Matchy::Expectations::TestCaseExtensions
        include Matchy::Assertions
        
        # Track the current testcase and 
        # provide it to the operator matchers.
        alias_method :old_run_method_aliased_by_matchy, :run
        def run(whatever, *args, &block)
          $current_test_case = self
          old_run_method_aliased_by_matchy(whatever, *args, &block)
        end
      end

      Object.class_eval { include Matchy::CustomMatcher }
    end
  end
end

autodetected_adapter = case
  when Matchy.minitest? then :minitest
  when Matchy.classic?  then :testunit
end
if autodetected_adapter
  Matchy.use(autodetected_adapter)
end