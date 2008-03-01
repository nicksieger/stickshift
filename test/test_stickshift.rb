require 'test/unit'
require 'stringio'
require 'stickshift'

class Foo
  def slow_method
    sleep 0.1
  end
  def hello
  end
end

class Bar
  def slow_method
    call_foo
  end

  def call_foo
    Foo.new.slow_method
  end

  def several_times
    10.times do
      slow_method
    end
  end

  def call(*args)
  end
end

class StickshiftTest < Test::Unit::TestCase
  def capture
    @save = $stdout
    @stdout = $stdout = StringIO.new
  end
  
  def teardown
    Foo.uninstrument_all
    Bar.uninstrument_all
    Array.uninstrument_all
    String.uninstrument_all
    $stdout = @save if @save
    puts @out if @out
  end

  def test_formatting
    Bar.instrument :slow_method, :several_times
    Foo.instrument :slow_method
    Bar.new.several_times
  end

  def test_output_profile
    Bar.instrument :slow_method
    Foo.instrument :slow_method
    capture
    Bar.new.slow_method
    @out = @stdout.string
    assert @out =~ /Bar#slow_method/
    assert @out =~ /Foo#slow_method/
  end

  def test_custom_label
    capture
    Foo.instrument :hello, :label => "Hello World!"
    Foo.new.hello
    assert @stdout.string =~ /Hello World!/
  end

  def test_instrument_uninstrument
    capture
    Foo.new.hello
    assert @stdout.string.empty?
    Foo.instrument :hello
    Foo.new.hello
    assert @stdout.string =~ /Foo#hello/
    @stdout.string = ''
    Foo.uninstrument :hello
    Foo.new.hello
    assert @stdout.string.empty?
  end

  def test_instrument_with_first_arg
    capture
    Bar.instrument :call, :with_args => 0
    Bar.new.call("abc")
    Bar.new.call("def")
    assert @stdout.string =~ /call.*"abc"/
    assert @stdout.string =~ /call.*"def"/
  end

  def test_instrument_operator_method
    capture
    Array.instrument :<<
    [] << 1
    assert @stdout.string =~ /<</
  end

  def test_instrument_label_self_inspect
    capture
    Array.instrument :length, :inspect_self => true
    %w(a b c).length
    assert @stdout.string =~ /"a", "b", "c"/
  end
end
