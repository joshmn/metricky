module Metricky
  class Base
    VALID_TYPES = [:sum, :max, :min, :average, :count].freeze
    attr_reader :params
    def initialize(params)
      @params = params
      @query = nil
    end

    # Must be one of Chartkick charts
    # line_chart, pie_chart, columnchart, bar_chart, areachart, geo_chart, timeline
    def chart
      :column_chart
    end

    # What partial is rendered.
    def to_partial_path
      '/metricky/metric'
    end

    def noun
      case type.to_sym
      when :count
        "total number of"
      when :average
        "average #{columns}"
      when :sum
        "total"
      when :min
        "minimum"
      when :max
        "maximum"
      end
    end

    # List of ranges and their values. Used (inverted) on the form.
    def self.ranges
      {
          'all' => 'All',
          'Today' => 'Today',
          '30' => '30 Days',
          '60' => '60 Days',
          '365' => '365 Days',
          'WTD' => 'WTD',
          'MTD' => 'MTD',
          'YTD' => 'YTD',
      }
    end

    # Actual result of the metric
    def results
      assets
    end

    def self.metric_name
      name.demodulize.sub(/Metric$/, "")
    end

    def title
      self.class.metric_name
    end

    def subtitle
      "#{noun} #{scope.model_name.human.pluralize}"
    end

    # Form key
    def form_name
      "#{uri_key}_metric"
    end

    # Param key
    def uri_key
      self.class.metric_name.tableize
    end

    # Converts range string to a Ruby object
    def range_value
      case range
      when nil
        nil
      when 'all'
        nil
      when '30'
        30.days.ago
      when '60'
        60.days.ago
      when '365'
        365.days.ago
      when 'WTD'
        DateTime.now.beginning_of_week
      when 'MTD'
        DateTime.now.beginning_of_month
      when 'YTD'
        DateTime.now.beginning_of_year
      when 'Today'
        DateTime.now.beginning_of_day
      else
        raise TypeError, "unknown range_value for range #{range}. Please define it on range_value"
      end
    end

    # What ActiveRecord class (or scoped class) is being used for  the metric
    def scope
      raise NotImplementedError, "please add a scope to your metric."
    end

    # What kind of metric we're pulling.
    #
    # Must be one of :sum, :max, :min, :average, :count
    def type
      :count
    end

    # Column(s) to perform the calculation on.
    # [:total_in_cents, :department]
    def columns
      'id'
    end

    # How it's grouped. Leave nil if no grouping
    #
    # [:second, :minute, :hour, :day, :week, :month, :quarter, :year, :day_of_week,
    # :hour_of_day, :minute_of_hour, :day_of_month, :month_of_year]
    def trend
      nil
    end

    # What column to specify for the range calculation. Normally `created_at`
    def range_column
      'created_at'
    end

    # What column to specify for the trend calculation. Normally `created_at`
    def trend_column
      'created_at'
    end

    def range
      params.dig(form_name, :range)
    end

    private

    def trend?
      trend.present?
    end

    def assets
      if range_value != nil
        @query = scope.where("#{range_column} > ?", range_value)
      else
        @query = scope
      end
      if trend? && valid_trend?
        @query = @query.group_by_period(trend, trend_column)
      end
      @query = @query.send(type, *columns)
      @query
    end

    def valid_trend?
      return true if Groupdate::PERIODS.include?(trend.to_sym)
      raise NameError, "trend must be one of #{Groupdate::PERIODS}. It is #{trend}."
    end

    def check_type
      unless VALID_TYPES.include?(type.to_sym)
        raise NameError, "#{type} must be one of :sum, :max, :min, :average, :count"
      end
    end
  end
end