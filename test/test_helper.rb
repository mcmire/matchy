# Here we are ensuring the following cases are easily testable:
#
# * Ruby 1.8 with Test::Unit (in standard library)
# * Ruby 1.8 with MiniTest (gem)
# * Ruby 1.8 with MiniTest-Test::Unit shim (minitest_tu_shim gem)
# * Ruby 1.8 with a different test library that uses parts from
#   Test::Unit (e.g. Protest)
# * Ruby 1.9.1 with MiniTest (in standard library)
# * Ruby 1.9.1 with Test::Unit (in standard library; acts like a
#   MiniTest-Test::Unit shim)
# * Ruby 1.9.1 with Test::Unit 1.2.3 (gem)
# * Ruby 1.9.1 with a different test library that uses parts from
#   Test::Unit (e.g. Protest)
#
# Note that Ruby 1.9.0 is NOT supported... but really, who's using
# that still :)
#
# To run through the tests, first go get RVM and install 1.9.1 using
# that. Then you can just say:
#
#   rvm use system
#   rake test USING=minitest_tu_shim
#   rake test USING=minitest
#   rake test USING=incompatible
#   rake test (uses test/unit by default)
#
# and then:
#
#   rvm use 1.9.1
#   rake test USING=minitest_tu_shim
#   rake test USING=testunit
#   rake test USING=incompatible
#   rake test (uses minitest/unit by default)
#
# References:
#
#   * http://blog.floehopper.org/articles/2009/02/02/test-unit-and-minitest-with-different-ruby-versions
#

if RUBY_VERSION.to_f < 1.9
  # Ruby 1.8.x
  case ENV["USING"]
    when "minitest_tu_shim"
      require 'rubygems'
      gem 'minitest'
      dir = Config::CONFIG["sitelibdir"]
      unless File.symlink?("#{dir}/minitest") && File.symlink?("#{dir}/test")
        #puts
        #puts "   ** To get a true test, you need to run `sudo use_minitest yes` to flip on minitest_tu_shim mode."
        #puts
        #exit 1
        puts "Enabling the shim..."; `sudo use_minitest yes`
        at_exit { puts "Disabling the shim..."; `sudo use_minitest no` }
      end
      require 'test/unit'
    when "minitest"
      require 'rubygems'
      gem 'minitest'
      require 'minitest/unit'
    when "incompatible"
      require 'rubygems'
      gem 'protest'
      require 'protest'
    else
      require 'test/unit'
  end
else
  # Ruby 1.9.1 and above
  case ENV["USING"]
    when "minitest_tu_shim"
      require 'rbconfig'
      $:.unshift RbConfig::CONFIG['rubylibdir'] # in case you also have test-unit 1.2.3 installed
      require 'test/unit'
    when "testunit"
      gem 'test-unit', "= 1.2.3"
      require 'test/unit'
    when "incompatible"
      gem 'protest'
      require 'protest'
    else
      require 'minitest/unit'
  end
end

$MATCHY_DEBUG = true

require 'matchy'