Gem::Specification.new do |s|
  s.name = %q{stickshift}
  s.version = "0.1"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nick Sieger"]
  s.date = %q{2008-05-19}
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
