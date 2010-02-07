unless defined?(Test::Unit) || defined?(MiniTest)
  raise LoadError, "No testing library present! Either Test::Unit or MiniTest must be required before loading matchy" 
end

# Matchy works with either Test::Unit or MiniTest, on both Ruby 1.8 and >= 1.9.1.
# Note that Ruby 1.9.0 is NOT supported... but you should really be using 1.9.1 ;)
module Matchy
  def self.minitest_tu_shim?
    # We have to decide if we really have a suite of MiniTest tests.
    # Rails for example defines MiniTest, so to only check for
    # defined?(MiniTest) would be malicious
    defined?(MiniTest) && defined?(MiniTest::Assertions) &&
    defined?(Test::Unit::TestCase) && Test::Unit::TestCase < MiniTest::Assertions
  end
  
  def self.classic?
    defined?(Test::Unit) && defined?(Test::Unit::TestCase) && !minitest_tu_shim?
  end
  
  def self.minitest?
    !classic?
  end
  
  def self.assertions_module
    minitest? ? MiniTest::Assertions : Test::Unit::Assertions
  end
  
  def self.test_case_class
    minitest? ? MiniTest::Unit::TestCase : Test::Unit::TestCase
  end
  
  def self.assertion_failed_error
    minitest? ? MiniTest::Assertion : Test::Unit::AssertionFailedError
  end
end
MiniTest::Unit.autorun if Matchy.minitest?

if $MATCHY_DEBUG
  puts
  print " -- This is Ruby version #{RUBY_VERSION}, using "
  if Matchy.minitest_tu_shim?
    puts "MiniTest-Test::Unit shim"
  elsif Matchy.minitest?
    puts "MiniTest"
  else
    puts "Test::Unit"
  end
  puts
end

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

# Track the current testcase and 
# provide it to the operator matchers.
Matchy.test_case_class.class_eval do
  alias_method :old_run_method_aliased_by_matchy, :run
  def run(whatever, *args, &block)
    $current_test_case = self
    old_run_method_aliased_by_matchy(whatever, *args, &block)
  end
end

Matchy.test_case_class.send(:include, Matchy::Expectations::TestCaseExtensions)
include Matchy::CustomMatcher