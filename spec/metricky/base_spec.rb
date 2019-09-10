require 'spec_helper'

describe Metricky::Base do
  context 'defaults' do
    before(:all) do
      @metric = UsersMetric.new({})
    end
    it 'type is :count' do
      expect(@metric.type).to eq(:count)
    end
    it 'range_column is :created_at' do
      expect(@metric.range_column.to_s).to eq('created_at')
    end
    it 'trend_column is :created_at' do
      expect(@metric.period_column.to_s).to eq('created_at')
    end
    it 'trend is nil' do
      expect(@metric.period).to be_nil
    end
    it 'columns is id' do
      expect(@metric.columns).to eq('id')
    end
    it 'chart is :column_chart' do
      expect(@metric.chart).to eq(:column_chart)
    end
    it 'to_partial_path is metricky/metric' do
      expect(@metric.to_partial_path).to eq('/metricky/metric')
    end
    it 'uri_key is the table name' do
      expect(@metric.uri_key).to eq("users")
    end
    it 'form_name is the uri_key_metric' do
      expect(@metric.form_name).to eq("users_metric")
    end
  end
  context  'count calculations' do
    before(:all) do
      @metric = UsersMetric.new({})
    end
    it 'results are a count' do
      expect(@metric.results).to eq(5)
    end
  end
  context  'average calculations' do
    before(:all) do
      @metric = UsersTotalAverageMetric.new({})
    end
    it 'results are a count' do
      expect(@metric.results).to eq(0.3e1)
    end
  end
  context  'period calculations' do
    before(:all) do
      @metric = UsersMoneyByAge.new(HashWithIndifferentAccess.new({"users_money_by_ages_metric": { "range": '30d' }}))
    end
    it 'range is calculated correctly' do
      expect(@metric.range).to eq('30d')
      expect(@metric.range_to_value.to_date).to eq(30.days.ago.to_date)
      expect(@metric.results).to be_a(Hash)
    end
    it 'results are a hash' do
      results = @metric.results.as_json
      expect(results["1960-01-01"]).to eq(5)
      expect(results["1990-01-01"]).to eq(7)
      expect(results["1991-01-01"]).to eq(3)
    end
  end
  context 'periods' do
    it 'is invalid if period is not valid' do
      metric = UsersInvalidTrend.new
      expect { metric.results }.to raise_error(NameError)
    end
  end
end