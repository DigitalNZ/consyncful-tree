# Consyncful::Tree

For those already using the `consyncful` gem, `consyncful-tree` provides a few additional concerns to help with Consyncful models nested in a tree structure.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'consyncful-tree'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install consyncful-tree

## Usage

### Parent
Include the Consyncful::Tree::Parent concern in a Consyncful model that you want to keep track of the dependencies of.

```
class ModelName < Consyncful::Base
  include Consyncful::Tree::Parent

  ...
end
```

This will give you the following three methods that recursively traverse the `references_one` + `references_many` relationships:
```
lookup_child_model_ids

lookup_child_models

with_child_class_of?
```

### Child

Include the Consyncful::Tree::Child concern in any Consyncful model that is a dependency of a Consyncful::Tree::Parent and that should touch that parent when it is updated.

```
class ModelName < Consyncful::Base
  include Consyncful::Tree::Child

  ...
end
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).  You'll need an account on [rubygems.org](https://rubygems.org), you'll also need a current owner of the gem to add you as an owner.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DigitalNZ/consyncful-tree.
