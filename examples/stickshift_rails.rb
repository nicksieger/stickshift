# Instrument some of the main methods hit during a Rails request dispatch.
# Put stickshift.rb in the 'lib' directory of your rails app and this file
# in the config/initializers directory.

require 'stickshift'
require 'dispatcher'

class << Dispatcher; instrument :dispatch, :label => "Rails Dispatcher", :top_level => true; end
class << ActionController::Base; instrument :process; end
ActionController::Base.instrument :perform_action
ActionController::Base.instance_methods.select {|m| m =~ /^render/ }.each do |m|
  ActionController::Base.instrument m, :with_args => 0
end
ActionController::Routing::RouteSet.instrument :recognize
ActionView::Base.instrument :render

class << ActiveRecord::Base; instrument :find; end
ActiveRecord::Base.instrument :save
ActiveRecord::ConnectionAdapters.constants.each do |c|
  adapter_class = ActiveRecord::ConnectionAdapters.const_get(c)
  if adapter_class < ActiveRecord::ConnectionAdapters::AbstractAdapter
    adapter_class.instrument :execute, :with_args => 0
  end
end