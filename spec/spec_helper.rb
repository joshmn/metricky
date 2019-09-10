require "bundler/setup"
require "rails/all"
require "metricky"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

class TestApplication < Rails::Application
end

module Rails
  def self.root
    Pathname.new(File.expand_path("../", __FILE__))
  end

  def self.cache
    @cache ||= ActiveSupport::Cache::MemoryStore.new
  end

  def self.env
    "test"
  end
end

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define(version: 1) do
  create_table :users do |t|
    t.string :name, null: false
    t.string :total_in_cents, default: 0, null: false
    t.date :dob, default: 0, null: false
    t.datetime :created_at
    t.datetime :updated_at
  end
end
class User < ActiveRecord::Base
end

class UsersMetric < Metricky::Base
  def scope
    User
  end
end

class UsersTotalAverageMetric < Metricky::Base
  def scope
    User
  end
  def type
    :average
  end
end

class UsersMoneyByAge < Metricky::Base
  def scope
    User
  end
  def type
    :sum
  end
  def period_column
    'dob'
  end
  def period
    :year
  end
end

class UsersInvalidTrend < Metricky::Base
  def scope
    User
  end
  def period
    :dogs
  end
end

RSpec.configure do |config|
  config.before(:suite) do
    User.create!(name: "Josh", total_in_cents: 100, dob: "01/01/1991")
    User.create!(name: "Hannah", total_in_cents: 200, dob: "01/01/1991")
    User.create!(name: "Megan", total_in_cents: 300, dob: "01/01/1990")
    User.create!(name: "Zack", total_in_cents: 400, dob: "01/01/1990")
    User.create!(name: "Mom", total_in_cents: 500, dob: "01/01/1960")
  end
end

Rails.application.instance_variable_set("@initialized", true)
