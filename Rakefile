require 'rake/testtask'

Rake::TestTask.new
task :default => :test

desc "Run the instrumented rake example"
task :example do
  puts "# Here is the example Rakefile"
  puts *(File.readlines("examples/example.rake"))
  puts "# Running it"
  ruby "-Ilib -S rake -f examples/example.rake"
end