require 'benchmark'

module Stickshift
  class Timer
    def self.current
      Thread.current['__stickshift']
    end

    def self.current=(timer)
      Thread.current['__stickshift'] = timer
    end

    attr_reader :depth

    def initialize(obj, meth, options, *args)
      @depth = 1
      @elapsed = 0
      @options = options
      if @options[:label]
        @label = @options[:label]
      else
        klass = Class === obj ? "#{obj.name}." : "#{obj.class.name}#"
        @label = "#{klass}#{meth}"
      end
      if @options[:inspect_self]
        @label << "{#{obj.inspect}}"
      end
      @args = args
      @parent = Timer.current
      if @parent
        @parent.add(self)
        @depth = @parent.depth + 1
      end
    end

    def invoke(&block)
      Timer.current = self
      result = nil
      @elapsed = Benchmark.realtime do
        result = block.call
      end
      result
    ensure
      Timer.current = @parent
      unless @parent
        report
      end
    end

    def add(child)
      children << child
    end

    def children
      @children ||= []
    end

    def elapsed
      @elapsed ||= 0
    end

    def report
      $stdout.puts "#{format_str % self_time}ms >#{'  ' * @depth}#{@label}#{args} < #{total_time}ms"
      children.each {|c| c.report}
    end

    def ms(t)
      (t * 1000).to_i
    end

    def format_str
      @format_str ||= @parent.format_str if @parent
      @format_str ||= "%#{total_time.to_s.length}s"
    end

    def self_time
      @self_time ||= ms(elapsed - children.inject(0) {|sum,el| sum += el.elapsed}).to_s
    end

    def total_time
      ms(elapsed)
    end

    def args
      if @options[:with_args]
        "(#{@args[@options[:with_args]].inspect})"
      end
    end
  end
end

class Module
  def instrument(*meths)
    options = Hash === meths.last ? meths.pop : {}
    @__stickshift ||= {}
    meths.each do |meth|
      unless instrumented?(meth)
        mangled = _stickshift_mangle(meth)
        meth_opts = options.merge(:original => meth)
        @__stickshift[mangled] = meth_opts
        define_method("#{mangled}__instrumented") { meth_opts }
        alias_method "#{mangled}__orig_instrument", meth
        alias_method "#{mangled}__without_instrument", meth
        module_eval(<<-METH, __FILE__, __LINE__)
          def #{meth}(*args, &block)
            Stickshift::Timer.new(self, "#{meth}", #{mangled}__instrumented, *args).invoke do
              #{mangled}__without_instrument(*args, &block)
            end
          end
        METH
      end
    end
  end

  def instrumented?(meth)
    instance_methods.include?("#{_stickshift_mangle(meth)}__instrumented")
  end

  def uninstrument(*meths)
    meths.each do |meth|
      if instrumented?(meth)
        mangled = _stickshift_mangle(meth)
        remove_method "#{mangled}__instrumented"
        alias_method meth, "#{mangled}__orig_instrument"
      end
    end
  end

  def uninstrument_all
    uninstrument(*(instance_methods.select {|m| m =~ /__instrumented$/}.map {|m| @__stickshift[m[0...-14]][:original]}))
  end

  def _stickshift_mangle(meth)
    (s = meth.to_s) =~ /^[a-zA-Z_][a-zA-Z_0-9]*$/ ? s : "_#{s.unpack("H*")[0]}"
  end
end