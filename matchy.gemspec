Gem::Specification.new do |s|
  s.name = %q{matchy}
  s.version = "0.4.0"
  s.authors = ["Jeremy McAnally"]
  s.date = %q{2009-03-23}
  s.description = %q{RSpec-esque matchers for use in Test::Unit}
  s.email = ["jeremy@entp.com"]
  s.extra_rdoc_files = ["History.txt", "License.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc"]
  s.files = ["History.txt", "License.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "config/hoe.rb", "config/requirements.rb", "countloc.rb", "lib/matchy.rb", "lib/matchy/built_in/change_expectations.rb", "lib/matchy/built_in/enumerable_expectations.rb", "lib/matchy/built_in/error_expectations.rb", "lib/matchy/built_in/operator_expectations.rb", "lib/matchy/built_in/truth_expectations.rb", "lib/matchy/custom_matcher.rb", "lib/matchy/expectation_builder.rb", "lib/matchy/matcher_builder.rb", "lib/matchy/modals.rb", "lib/matchy/version.rb", "matchy.gemspec", "setup.rb", "tasks/deployment.rake", "tasks/environment.rake", "test/all.rb", "test/ruby1.9.compatibility_tests.rb", "test/test_change_expectation.rb", "test/test_custom_matcher.rb", "test/test_enumerable_expectations.rb", "test/test_error_expectations.rb", "test/test_expectation_builder.rb", "test/test_helper.rb", "test/test_matcher_builder.rb", "test/test_modals.rb", "test/test_operator_expectations.rb", "test/test_truth_expectations.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://matchy.rubyforge.org}
  s.post_install_message = %q{
For more information on matchy, see http://matchy.rubyforge.org

NOTE: Change this information in PostInstall.txt 
You can also delete it if you don't want it.

}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{matchy}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{RSpec-esque matchers for use in Test::Unit}
  s.test_files = ["test/test_change_expectation.rb", "test/test_custom_matcher.rb", "test/test_enumerable_expectations.rb", "test/test_error_expectations.rb", "test/test_expectation_builder.rb", "test/test_helper.rb", "test/test_matcher_builder.rb", "test/test_modals.rb", "test/test_operator_expectations.rb", "test/test_truth_expectations.rb"]
end