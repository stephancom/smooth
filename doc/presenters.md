## Presenters

Smooth::Resource classes expose an API for querying data, presenting it
it as a desired view, and customizing that presentation for the role of
the user querying the API.

Given the following model configuration:

```ruby
class Person < ActiveRecord::Base
  include Smooth::Resource
end

class PersonPresenter
  def self.default
    [:name, :public_profile_attributes]
  end

  def self.admin_default
    default + [:coolness_rating, :black_listed?]
  end
end
```

We will eventually query this resource through the Smooth::Presentable::Controller
and will end up making our call to the Query API via the following
chain:

If we are an admin:

```
# uses the admin_default presenter
Person.present(query).as(:default).to(:admin)
```

If we are something else, that is not defined, it defaults:

```
# uses the default presenter
Person.present(query).as(:default).to(:something_else)
```






