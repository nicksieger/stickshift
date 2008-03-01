
task :sleep => :snooze do
  sleep 1
end

task :snooze do
  sleep 2
end

task :default => :sleep

require 'stickshift'
::Rake::Application.instrument :top_level
::Rake::Application.instrument :[], :with => 0
::Rake::Task.instrument :invoke, :execute, :inspect_self => true
