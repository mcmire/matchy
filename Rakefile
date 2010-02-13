require 'rubygems'
require 'rake'

require File.dirname(__FILE__) + '/lib/matchy/version'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.version = Matchy::VERSION::STRING
    gem.name = "mcmire-matchy"
    gem.summary = %Q{RSpec-esque matchers for use in Test::Unit}
    gem.description = %Q{RSpec-esque matchers for use in Test::Unit}
    gem.email = ["jeremy@entp.com"]
    gem.homepage = %q{http://matchy.rubyforge.org}
    gem.authors = ["Jeremy McAnally"]
    gem.files.exclude ".gitignore", "test/*", "*.gemspec"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
  
  task :test => :check_dependencies
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "matchy #{Matchy::VERSION::STRING}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end