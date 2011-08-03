module Stickshift
  class << self
    attr_accessor :enabled, :top_level_trigger, :output
    alias_method :enabled?, :enabled
  end
  @enabled = true
  @output = $stdout

  class Timer
    def self.current;         Thread.current['__stickshift']; end
    def self.current=(timer); Thread.current['__stickshift'] = timer; end
    attr_reader :depth

    def initialize(obj, meth, options, *args)
      @depth, @options, @args = 1, options, args
      @label = if @options[:label]
        @options[:label]
      else
        klass = Class === obj ? "#{obj.name}." : "#{obj.class.name}#"
        "#{klass}#{meth}"
      end
      @label << "{#{obj.inspect}}"                         if @options[:inspect_self]
      @label << "(#{@args[@options[:with_args]].inspect})" if @options[:with_args]
      if @parent = Timer.current
        @parent.add(self)
        @depth = @parent.depth + 1
      end
    end

    def enabled?
     Stickshift.enabled && (Timer.current || Stickshift.top_level_trigger.nil? || @options[:top_level])
    end

    def invoke(&block)
      return block.call unless enabled?
      begin
        Timer.current = self
        result = nil
        @elapsed = realtime do
          result = block.call
        end
        result
      ensure
        Timer.current = @parent
        report unless @parent
      end
    end

    def realtime
      start = Time.now
      yield
      Time.now - start
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
      Stickshift.output.puts "#{self_format % self_time}ms >#{'  ' * @depth}#{@label} < #{total_time}ms"
      children.each {|c| c.report}
    end

    def ms(t)
      (t * 1000)
    end

    def self_format
      @self_format ||= if @parent
        @parent.self_format
      else
        width = ("%0.2f" % total_time).length
        "%#{width}.2f"
      end
    end

    def self_time
      @self_time ||= ms(elapsed - children.inject(0) {|sum,el| sum += el.elapsed})
    end

    def total_time
      ms(elapsed)
    end
  end
end

class Module
  def instrument(*meths)
    options = Hash === meths.last ? meths.pop : {}
    Stickshift.top_level_trigger = true if options[:top_level]
    @__stickshift ||= {}
    meths.each do |meth|
      unless instrumented?(meth)
        mangled   = __stickshift_mangle(meth)
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

  RESTRICTED_CLASSES = [String]
  RESTRICTED_METHODS = %w(inspect __send__ __id__)

  def instrumented?(meth)
    RESTRICTED_CLASSES.include?(self) ||
      RESTRICTED_METHODS.include?(meth.to_s) ||
      meth =~ /__instrumented$/ ||
      instance_methods.include?("#{__stickshift_mangle(meth)}__instrumented")
  end

  def uninstrument(*meths)
    meths.each do |meth|
      if instrumented?(meth)
        remove_method "#{__stickshift_mangle(meth)}__instrumented"
        alias_method meth, "#{__stickshift_mangle(meth)}__orig_instrument"
      end
    end
  end

  def uninstrument_all
    uninstrument(*(instance_methods.select {|m| m =~ /__instrumented$/}.map {|mi| @__stickshift[mi[0...-14]][:original]}))
  end

  def __stickshift_mangle(meth)
    (s = meth.to_s) =~ /^[a-zA-Z_][a-zA-Z0-9_]*$/ ? s : "_#{s.unpack("H*")[0]}"
  end
end
