class Object
  def self.deprecate_and_alias_method(new_method, old_method)
    define_method(old_method) do
      ActiveSupport::Deprecation.warn("#{old_method} is deprecated. Use #{new_method} instead.")
      send(new_method)
    end
  end
end