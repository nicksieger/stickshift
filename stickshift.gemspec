# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{stickshift}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nick Sieger"]
  s.date = %q{2011-08-03}
  s.description = %q{Stickshift is a simple, manual-instrumenting call-tree profiler in as few lines of code as possible.}
  s.email = %q{nick@nicksieger.com}
  s.extra_rdoc_files = ["History.txt", "LICENSE.txt", "Manifest.txt"]
  s.files = ["examples/example.rake", "examples/stickshift_rails.rb", "History.txt", "lib/stickshift/version.rb", "lib/stickshift.rb", "LICENSE.txt", "Manifest.txt", "Rakefile", "README.markdown", "stickshift.gemspec", "test/test_stickshift.rb", ".gemtest"]
  s.homepage = %q{http://caldersphere.rubyforge.org/stickshift}
  s.rdoc_options = ["--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{caldersphere}
  s.rubygems_version = %q{1.5.1}
  s.summary = %q{Stickshift is a pedal-to-the-metal manual profiler.}
  s.test_files = ["test/test_stickshift.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_development_dependency(%q<hoe>, ["~> 2.10"])
    else
      s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_dependency(%q<hoe>, ["~> 2.10"])
    end
  else
    s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
    s.add_dependency(%q<hoe>, ["~> 2.10"])
  end
end
