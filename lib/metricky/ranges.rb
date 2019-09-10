module Metricky
  class Base
    class_attribute :ranges, default: {}
    class_attribute :excluded_ranges, default: []
    class_attribute :default_range_key, default: 'all'

    def self.default_range(val = nil)
      self.default_range_key = val
    end

    # Rewrite the priority of a range thing.
    #
    # class UserMetric
    #   range_priority '24h', 99
    # end
    def self.range_priority(key, priority)
      self.ranges[key.to_s].priority = priority
    end

    # Register a range. Priority is used for the select order.
    #
    # @param [String] key The value for the option in the select for the form
    # @param [String] label The text shown on the option in the select for the form
    # @param [Integer] priority What order the resulting collection
    # @param [Block/Proc] block The Ruby-converted value. Usually a DateTime/Date/Time object.
    #
    # class UserMetric
    #   register_range '15w', label: '15 weeks', priority: 99 do
    #     15.weeks.ago
    #   end
    # end
    #
    # @return RangeThing
    def self.register_range(key, label: nil, priority: nil, &block)
      label ||= key
      priority ||= self.ranges.size
      self.ranges[key.to_s] = RangeThing.new(label, priority, block)
    end

    # Removes the listed ranges from the select
    def self.remove_ranges(*keys)
      keys.each { self.remove_range(key) }
    end

    def self.remove_range(key)
      self.excluded_ranges << key.to_s
    end

    register_range 'all', label: 'All' do
      nil
    end

    register_range 'today', label: 'Today' do
      DateTime.now.beginning_of_day
    end

    register_range '24h', label: '24 hours' do
      24.hours.ago
    end

    [3, 7, 10, 14, 21, 30].each do |day|
      register_range "#{day}d", label: "#{day} Days" do
        day.days.ago
      end
    end

    register_range "MTD", label: "MTD" do
      DateTime.now.beginning_of_month
    end

    register_range "QTD", label: "QTD" do
      DateTime.now.beginning_of_quarter
    end

    register_range "YTD", label: "YTD" do
      DateTime.now.beginning_of_year
    end

    # Lookup the passed range and convert it to a value for our ActiveRecord query
    def range_to_value
      return nil if range.nil?
      if val = self.ranges[range]
        val.value.call
      else
        raise TypeError, "invalid range #{range}. Please define it."
      end
    end
    deprecate_and_alias_method :range_to_value, :range_value

    # What column to specify for the range calculation. Normally `created_at`
    def range_column
      'created_at'
    end

    def range
      params.dig(form_name, :range) || default_range_key
    end

    # Used in the HTML form for the metric as the select options
    def range_collection
      ranges.except(*excluded_ranges).sort_by { |_, range| range.priority }.collect { |key, range_thing| [range_thing.label, key] }
    end
  end
end