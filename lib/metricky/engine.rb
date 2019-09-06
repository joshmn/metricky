require 'rails'

module Metricky
  class Engine < Rails::Engine
    isolate_namespace Metricky
  end
end
