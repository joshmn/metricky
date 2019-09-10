require "groupdate"
require "chartkick"
require 'metricky/core_ext'
require 'active_support/core_ext'
require 'active_support/concern'
require "metricky/range_thing"
require "metricky/ranges"
require "metricky/base"
require "metricky/helper"
require "metricky/engine"

module Metricky; end

ActiveSupport.on_load(:action_view) do
  include Metricky::Helper
end