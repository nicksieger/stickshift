
# Gem::Specification for Stickshift-0.1
# Originally generated by Echoe

Gem::Specification.new do |s|
  s.name = %q{stickshift}
  s.version = "0.1"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nick Sieger"]
  s.date = %q{2008-05-31}
  s.description = %q{Stickshift is a simple, manual-instrumenting call-tree profiler in as few lines of code as possible.}
  s.email = %q{nick@nicksieger.com}
  s.extra_rdoc_files = ["lib/stickshift/version.rb", "lib/stickshift.rb", "LICENSE.txt", "README.markdown"]
  s.files = ["examples/example.rake", "examples/stickshift_rails.rb", "History.txt", "lib/stickshift/version.rb", "lib/stickshift.rb", "LICENSE.txt", "Manifest", "Rakefile", "README.markdown", "stickshift.gemspec", "test/test_stickshift.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://caldersphere.rubyforge.org/stickshift}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Stickshift", "--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{caldersphere}
  s.rubygems_version = %q{1.0.1}
  s.summary = %q{Stickshift is a pedal-to-the-metal manual profiler.}
  s.test_files = ["test/test_stickshift.rb"]
end


# # Original Rakefile source (requires the Echoe gem):
# 
# require 'rake/testtask'
# 
# begin
#   require 'echoe'
#   require File.dirname(__FILE__) + '/lib/stickshift/version'
#   echoe = Echoe.new("stickshift", Stickshift::VERSION) do |p|
#     p.rubyforge_name = "caldersphere"
#     p.url = "http://caldersphere.rubyforge.org/stickshift"
#     p.author = "Nick Sieger"
#     p.email = "nick@nicksieger.com"
#     p.summary = "Stickshift is a pedal-to-the-metal manual profiler."
#     p.description = "Stickshift is a simple, manual-instrumenting call-tree profiler in as few lines of code as possible."
#     p.include_rakefile = true
#   end
# 
#   task :gemspec do
#     File.open("#{echoe.name}.gemspec", "w") {|f| f << echoe.spec.to_ruby }
#   end
#   task :package => :gemspec
# rescue LoadError
#   puts "You need echoe installed to be able to package this gem"
# end
# 
# # Hoe has its own test, but I want Rake::TestTask
# Rake::Task['test'].send :instance_variable_set, "@actions", []
# Rake::TestTask.new
# 
# task :default => :test
# 
# desc "Run the instrumented rake example"
# task :example do
#   puts "# Here is the example Rakefile"
#   puts *(File.readlines("examples/example.rake"))
#   puts "# Running it"
#   ruby "-Ilib -S rake -f examples/example.rake"
# end