module Metricky
  module Helper
    def metric_form_for(metric)
      form_for("#{request.path}", as: metric.form_name.to_sym, method: :get) do |f|
        yield(f)
      end
    end

    def render_metric(metric_name)
      if metric_name.is_a?(String) || metric_name.is_a?(Symbol)
        metric_name = metric_name.to_s
        if metric_name.end_with?("Metric")
          metric = metric_name.safe_constantize
        else
          klass_name = "#{metric_name.to_s}Metric".camelize
          metric = "Metrics::#{klass_name}".safe_constantize
        end
        raise NameError, "#{metric_name} does not exist" unless metric
      else
        metric = metric_name
      end
      metric = metric.new(params)
      render metric, metric: metric
    end

    def metricky_chart(metric)
      send(metric.chart, metric.results)
    end
  end
end