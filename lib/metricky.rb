require "groupdate"
require "chartkick"
require "metricky/base"
require "metricky/helper"

require "metricky/engine"

module Metricky
end

ActiveSupport.on_load(:action_view) do
  include Metricky::Helper
end