# Metricky
Display metrics about your database in your application. Depends on the awesome [Chartkick](https://github.com/ankane/chartkick) and [Groupdate](https://github.com/ankane/groupdate).

## Usage

Make this in Ruby:

<img src="https://i.imgur.com/PQhFyAE.png" alt="Metricky example">

## Generate it 

`rails g metricky:metric TotalUsersMetric --scope User --type :count --period :day`

## Display it 

In your view where you want to display the metric: 

```erbruby
render_metric :total_users
```

## Customize it 

In `app/metrics/total_users_metric.rb`

```ruby 
class TotalUsersMetric < ApplicationMetric 
  def scope
    User
  end

  def type
    :count
  end

  def period
    :day 
  end
end
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'metricky'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install metricky
```

Then drop in Chartkick into your `application.js` (or similar):

```javascript
//= require chartkick
```

## Customizing

~~Blatantly ripped from~~ Super-inspired by Laravel Nova's metric system.

### Value to calculate

In your metric, define columns:

```ruby 
def columns
  :id 
end
```

### Grouping by period (day, month, year, quarter, etc.)

In your metric, define what period:

```ruby
def period 
  :day 
end
```

This can be any one of `Groupdate::PERIODS`

Define what column should be used:

```ruby
def period_column
  :created_at 
end
```

### Value type 

In your metric, define what type:

```ruby
def type 
  :count 
end
```

This can be any one of `:min, :max, :sum, :count, :average`

### Ranges

In your metric, define what ranges as a class method:

```ruby
def self.ranges
  {
      'all' => 'All',
      '30' => '30 Days',
      '60' => '60 Days',
      '365' => '365 Days',
  }
end
```

And then their corresponding values (instance-level):

```ruby 
def range_value
  case range
  when 'all'
    nil
  when '30'
    30.days.ago
  when '60'
    60.days.ago
  when '365'
    365.days.ago
  end
end
```

This is used with a `where` query against the `range_column`.

```ruby 
def range_column
  :created_at
end
```

### Partial

In your metric, define the partial path:

```ruby 
def to_partial_path
  "shared/metric"
end
```

Take a look at `app/views/metricky/_metric.html.erb` for implementation.

## Contributing
Add stuff.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
