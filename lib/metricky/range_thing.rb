module Metricky
  class RangeThing
    attr_reader :label, :priority, :value
    def initialize(label, priority, value)
      @label = label
      @priority = priority
      @value = value
    end
  end
end