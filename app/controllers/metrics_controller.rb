class Metricky::MetricsController < ActionController::Base
  def show
    metric = "#{params[:name].classify}Metric".constantize.new(params[:query] || {}, params[:options] || {})
    unless metric.results.is_a?(Hash) || metric.results.is_a?(Array)
      raise RenderError, "results must be a hash or array"
    end
    render json: metric.to_json
  end
end