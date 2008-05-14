require 'rake/testtask'

MANIFEST = FileList["History.txt", "Manifest.txt", "README.txt", "LICENSE.txt",
  "Rakefile", "examples/**/*", "lib/**/*", "test/**/*.rb"]

begin
  File.open("Manifest.txt", "w") {|f| MANIFEST.each {|n| f << "#{n}\n"} }
  require 'hoe'
  require File.dirname(__FILE__) + '/lib/stickshift/version'
  hoe = Hoe.new("stickshift", Stickshift::VERSION) do |p|
    p.rubyforge_name = "caldersphere"
    p.url = "http://caldersphere.rubyforge.org/stickshift"
    p.author = "Nick Sieger"
    p.email = "nick@nicksieger.com"
    p.summary = "Stickshift is a pedal-to-the-metal manual profiler."
    p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
    p.description = p.paragraphs_of('README.txt', 0...1).join("\n\n")
    # p.test_globs = ["spec/**/*_spec.rb"]
    p.rdoc_pattern = /\.(rb|txt)/
  end
  hoe.spec.files = MANIFEST
  hoe.spec.dependencies.delete_if { |dep| dep.name == "hoe" }

  task :gemspec do
    File.open("#{hoe.name}.gemspec", "w") {|f| f << hoe.spec.to_ruby }
  end
  task :package => :gemspec
rescue LoadError
  puts "You really need Hoe installed to be able to package this gem"
end

# Hoe has its own test, but I want Rake::TestTask
Rake::Task['test'].send :instance_variable_set, "@actions", []
Rake::TestTask.new

desc "Run the instrumented rake example"
task :example do
  puts "# Here is the example Rakefile"
  puts *(File.readlines("examples/example.rake"))
  puts "# Running it"
  ruby "-Ilib -S rake -f examples/example.rake"
end