# Metricky
Display metrics about your database in your application. Depends on the awesome [Chartkick](https://github.com/ankane/chartkick) and [Groupdate](https://github.com/ankane/groupdate).

## Demo (with code!)

[metricky-demo.herokuapp.com](https://metricky-demo.herokuapp.com)

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

### Sending more data into the metric

Need to pass `current_user`? 

```erbruby
render_metric :users, user: current_user, account: current_account
```

`user` and `account` will be `attr_reader`-ized.

### Value to calculate

In your metric, define columns:

```ruby 
def columns
  :id 
end
```

### Grouping the value

To `User.all.group(:color).count`

```ruby
def group
  :color 
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

Ranges are what values are available on the form (used to query the metric, if applicable) via the `range_column`

```ruby 
def range_column
  :created_at
end
```

Defaults are `all`, `today`, `24 hours`, `3 days`, `7 days`, `10 days`, `14 days`, `30 days`, `3 months`, `6 months`, `12 months`

#### Creating a new range
In your metric, define what ranges as a class method:

```ruby
class TotalUsersMetric < ApplicationMetric
  register_range '15h', label: "15 hours" do 
    15.hours.ago   
  end
end
```

#### Removing a range

```ruby
class TotalUsersMetric < ApplicationMetric
  remove_ranges '24h', '7d' # an array 
  remove_range '3d' # individual 
end
```

#### Removing all ranges

```ruby
class TotalUsersMetric < ApplicationMetric
  reset_ranges!
end
```

#### Setting the default range 

```ruby
class TotalUsersMetric < ApplicationMetric
  default_range '24h'
end
```

#### Customizing the label

Use `collection_label`

```ruby 
class TotalUsersMetric < ApplicationMetric
  def collection_label(range_thing)
    "Born #{range_thing.value.call}"
  end
end 
```

Need helpers? `h`

```
class TotalUsersMetric < ApplicationMetric
  def collection_label(range_thing)
    "Born #{h.time_ago_in_words(range_thing.value.call)}"
  end
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
