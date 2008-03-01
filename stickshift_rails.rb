require 'stickshift'
require 'dispatcher'

class << Dispatcher; instrument :dispatch, :as => "Rails Dispatcher"; end
class << ActionController::Base; instrument :process; end
ActionController::Base.instrument :perform_action
ActionController::Base.instance_methods.select {|m| m =~ /^render/ }.each do |m|
  ActionController::Base.instrument m, :with => 0
end
ActionController::Routing::RouteSet.instrument :recognize
ActionView::Base.instrument :render

class << ActiveRecord::Base; instrument :find; end
ActiveRecord::ConnectionAdapters.constants.each do |c|
  adapter_class = ActiveRecord::ConnectionAdapters.const_get(c)
  if adapter_class < ActiveRecord::ConnectionAdapters::AbstractAdapter
    adapter_class.instrument :execute, :with => 0
  end
end