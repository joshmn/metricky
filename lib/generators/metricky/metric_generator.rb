module Metricky
  module Generators
    class MetricGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)
      check_class_collision suffix: "Metric"

      class_option :scope, type: :string, aliases: %i(--scope), default: '', desc: "What class or scoped class this metric pulls from. Required."
      class_option :type, type: :string, aliases: %i(--type), default: ':count', desc: "What type of metric — one of :count, :max, :min, :sum, :average. Default is :count"
      class_option :period, type: :string, default: 'nil', aliases: %i{--period}, desc: "What class or scoped class this metric pulls from (optional)"
      class_option :group, type: :string, default: 'nil', aliases: %i{--group}, desc: "Specify what attribute to group by (optional)"

      def create_metric_file
        template "metric.rb", File.join("app/metrics", class_path, "#{file_name}_metric.rb")
        in_root do
          if behavior == :invoke && !File.exist?(application_metric_file_name)
            template "application_metric.rb", application_metric_file_name
          end
        end
      end

      private

      def file_name # :doc:
        @_file_name ||= super.sub(/_metric\z/i, "")
      end

      def application_metric_file_name
        @_application_mailer_file_name ||= if mountable_engine?
                                             "app/metrics/#{namespaced_path}/application_metric.rb"
                                           else
                                             "app/metrics/application_metric.rb"
                                           end
      end
    end
  end
end
