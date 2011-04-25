require 'rake/testtask'

begin
  require 'hoe'
  Hoe.plugin :rubyforge
  hoe = Hoe.spec("stickshift") do |p|
    require File.dirname(__FILE__) + '/lib/stickshift/version'
    p.version = Stickshift::VERSION
    p.rubyforge_name = "caldersphere"
    p.url = "http://caldersphere.rubyforge.org/stickshift"
    p.readme_file = "README.markdown"
    p.author = "Nick Sieger"
    p.email = "nick@nicksieger.com"
    p.summary = "Stickshift is a pedal-to-the-metal manual profiler."
    p.description = "Stickshift is a simple, manual-instrumenting call-tree profiler in as few lines of code as possible."
  end

  task :gemspec do
    File.open("#{hoe.name}.gemspec", "w") {|f| f << hoe.spec.to_ruby }
  end
  task :package => :gemspec
rescue LoadError
  puts "You need hoe installed to be able to package this gem"
end

# Hoe has its own test, but I want Rake::TestTask
Rake::Task['test'].send :instance_variable_set, "@actions", []
Rake::TestTask.new

task :default => :test

desc "Run the instrumented rake example"
task :example do
  puts "# Here is the example Rakefile"
  puts *(File.readlines("examples/example.rake"))
  puts "# Running it"
  ruby "-Ilib -S rake -f examples/example.rake"
end
