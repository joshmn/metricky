class UserMetric < ApplicationMetric
  def scope
    User
  end

  def type
    :count
  end
end
