Stickshift is a simple, manual-instrumenting call-tree profiler in as
few lines of code as possible.

## Background

The idea is to be as minimally intrusive as possible, but also to be
stupid simple and manual. You tell stickshift to only instrument the
methods you want, and it measures time spent in that method, as well
as any time spent in any instrumented methods invoked by the method.
After leaving the top-most method, a call tree with timings is dumped
to $stdout.

WARNING: You can't instrument methods on the Benchmark or String
classes, or any object's #inspect method, or you will generate a
recursive loop! For fine-grained profiling on any arbitrary class, use
profiler or ruby-prof instead.

## Example

Consider the following Rakefile:

    task :sleep => :snooze do
      sleep 1
    end
    task :snooze do
      sleep 2
    end
    task :default => :sleep

    require 'stickshift'
    ::Rake::Application.instrument :top_level
    ::Rake::Application.instrument :[], :with_args => 0
    ::Rake::Task.instrument :invoke, :execute, :inspect_self => true

Running 'rake' will produce the following output. Method self time is
shown along the left, while method total time is at the end of each
line.

       0ms >  Rake::Application#top_level < 3001ms
       0ms >    Rake::Application#[]("default") < 0ms
       0ms >    Rake::Task#invoke{<Rake::Task default => [sleep]>} < 3001ms
       0ms >      Rake::Application#[]("sleep") < 0ms
       0ms >      Rake::Application#[]("snooze") < 0ms
    2000ms >      Rake::Task#execute{<Rake::Task snooze => []>} < 2000ms
    1000ms >      Rake::Task#execute{<Rake::Task sleep => [snooze]>} < 1000ms
       0ms >      Rake::Task#execute{<Rake::Task default => [sleep]>} < 0ms

## Instrumentation

Stickshift adds a method named #instrument to the Module class that
instruments methods in the receiver module or class.

It accepts one or more method names, and an optional trailing hash of
options:

* `:label => "label"` gives the instrumented method a custom label
  instead of the default "Class#method" label.
* `:with_args => 0` causes the first argument to the method to be
  included in the label. Ranges can also be used.
* `:inspect_self => true` causes the inspected object to be printed in
  the label.
* `:top_level => true` causes Stickshift to only be activated after
  passing through this method. If any other non-top-level instrumented
  method is called outside of a top-level method, it will not be timed
  or reported.

`#uninstrument` and `#uninstrument_all` methods are also available if
you wish to disable instrumentation.

## Capture/Settings

* `Stickshift.enabled` (default `true`) controls whether Stickshift is
  on or not.
* `Stickshift.output` (default `$stdout`) controls where output is
  written. The object must respond to `#puts(*lines)`.
