module Metricky
  class Base
    # How it's grouped. Leave nil if no grouping
    #
    # [:second, :minute, :hour, :day, :week, :month, :quarter, :year, :day_of_week,
    # :hour_of_day, :minute_of_hour, :day_of_month, :month_of_year]
    def period
      nil
    end
    deprecate_and_alias_method :period, :trend

    # What column to specify for the period calculation. Normally `created_at`
    def period_column
      'created_at'
    end
    deprecate_and_alias_method :period_column, :trend_column

    private

    def period?
      period.present?
    end
    deprecate_and_alias_method :period?, :trend?

    def valid_period?
      return true unless period?
      Groupdate::PERIODS.include?(period.to_sym)
    end
    deprecate_and_alias_method :valid_period?, :valid_trend?
  end
end