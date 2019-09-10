module Metricky
  module Helper
    def metric_form_for(metric)
      form_for("#{request.path}", as: metric.form_name.to_sym, method: :get) do |f|
        yield(f)
      end
    end

    def metrick_path(metric, options = {})
      Metricky::Engine.routes.url_helpers.metric_path(name: metric.name.underscore, query: request.query_parameters, options: options)
    end

    def render_metric(metric_name, options = {})
      if metric_name.is_a?(String) || metric_name.is_a?(Symbol)
        metric_name = metric_name.to_s
        if metric_name.end_with?("Metric")
          metric = metric_name.safe_constantize
        else
          klass_name = "#{metric_name.to_s}Metric".camelize
          metric = "#{klass_name}".safe_constantize
        end
        raise NameError, "#{metric_name} does not exist" unless metric
      else
        metric = metric_name
      end
      metric = metric.new(params, options)
      render metric, metric: metric
    end

    def metricky_chart(metric, options = {})
      if metric.json?
        send(metric.chart, metrick_path(metric, options))
      else
        send(metric.chart, metric.results, options)
      end
    end
  end
end