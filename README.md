# RSpec::CheckstyleFormatter

Format the results of the rspec execution into checksytle format.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-checkstyle_formatter'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rspec-checkstyle_formatter

## Usage

```
$ bundle exec rspec --format RSpec::CheckstyleFormatter
```

### With reviewdog

Post the output of rspec to github using a [reviewdog](https://github.com/reviewdog/reviewdog).

A sample of GithubActions.

```
name: CI

on: push

jobs:
  test:
    name: Test
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2

    - name: Set up Ruby
      uses: ruby/setup-ruby@v1

    - name: Restore gems
      uses: actions/cache@v2
      with:
        path: vendor/bundle
        key: ${{ runner.os }}-gems-${{ hashFiles('**/Gemfile.lock') }}
        restore-keys: |
          ${{ runner.os }}-gems-

    - name: Run rspec
      run: |
        bundle exec rspec \
          --no-fail-fast \
          --format RSpec::CheckstyleFormatter \
          --out /tmp/rspec_result.xml

    - name: Upload rspec result
      if: always()
      uses: actions/upload-artifact@v2
      with:
        name: rspec_result.xml
        path: /tmp/rspec_result.xml

    - name: Install reviewdog
      if: always()
      uses: reviewdog/action-setup@v1
      with:
        reviewdog_version: latest

    - name: Report rspec error
      if: always()
      env:
        REVIEWDOG_GITHUB_API_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      run: |
        cat /tmp/rspec_result.xml | reviewdog -name=rspec -f=checkstyle -reporter=github-check -filter-mode=nofilter
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rspec-checkstyle_formatter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/rspec-checkstyle_formatter/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RSpec::CheckstyleFormatter project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rspec-checkstyle_formatter/blob/master/CODE_OF_CONDUCT.md).
