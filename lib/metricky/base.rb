require 'metricky/period'
require 'metricky/ranges'

module Metricky
  class Base
    VALID_TYPES = [:sum, :max, :min, :average, :count].freeze
    attr_reader :params, :query
    def initialize(params, options = {})
      @params = params
      options.each do |k,v|
        self.class.attr_reader k
        self.instance_variable_set("@#{k}", v)
      end
      @query = nil
    end

    # Must be one of Chartkick charts
    # line_chart, pie_chart, columnchart, bar_chart, areachart, geo_chart, timeline
    def chart
      :column_chart
    end

    def chart_options
      @chart_options ||= {}
    end

    # What partial is rendered.
    def to_partial_path
      '/metricky/metric'
    end

    def noun
      {
          count: "total number of",
          average: "average #{columns} of",
          sum: "total",
          min: "minimum",
          max: "maximum"
      }[type.to_sym]
    end

    # Actual result of the metric
    def results
      assets
    end

    def name
      self.class.metric_name
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

    # If you have a static metric that doesn't need to be queried (e.g. average users age of all users), disable the form
    def form?
      ranges.any?
    end

    def chart?
      results.is_a?(Hash) || results.is_a?(Array)
    end

    def to_json
      results.chart_json
    end

    def group
      false
    end

    def group?
      group.present?
    end

    def json?
      false
    end

    private

    def assets
      @query = scope
      unless range_to_value.nil?
        @query = scope.where("#{range_column} > ?", range_to_value)
      end
      if period? && valid_period?
        @query = @query.group_by_period(period, period_column)
      end
      if group?
        @query = @query.group(group)
      end
      if valid_type?
        @query = @query.send(type, *columns)
      else
        raise TypeError, "#{type} is not a valid type."
      end
      if @query.is_a?(Hash)
        @query.transform_values! { |value| format_value(value) }
      else
        @query = format_value(@query)
      end
      @query
    end

    def h
      @h ||= ActionController::Base.helpers
    end

    def format_value(value)
      value
    end

    def valid_type?
      VALID_TYPES.include?(type.to_sym)
    end
  end
end