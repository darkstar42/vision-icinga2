# Testing

## Prerequisites

`Docker` and `ruby` need to be installed on the local machine.

## Running Tests

After cloning the repository the testing environment should be set up on the
local machine:

```
$ bundle install --path vendor
$ bundle exec rake
```

With running `rake` the whole testsuite is triggered, this
includes:

  * puppet syntax validation
  * code-style enforcement (with `puppet-lint`)
  * unit-tests (with `rspec-puppet`)
  * acceptance-tests (with `beaker-rspec`)
