# Fife

**Fife** is a multiple IO pipelining tool, originally designed for
file uploading through HTTP, but can be used in any other cases.

## Warning
This gem is in early development stage, and the interface could be changed enormously in future releases.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fife'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fife

## Usage

Create a `Fife` instance by calling `Fife(io_ary)`,
then chain as many `pipe` calls as you want.

```ruby
io_ary = [
  File.new('/path/to/my/file'),
  StringIO.new('Hello world'),
  Tempfile.new('temp')
]

Fife(io_ary).pipe(-> io {io})
            .pipe(-> io {[io, io]})
            .pipe(:close)
```

### Kernel#Fife(*ios)

This method returns a `Fife::Pipe` instance for chaining.

This method expect 0 or more IO-like objects as arguments.
Alternatively it can take an array of IO-like objects

### Fife::Pipe#pipe

This method returns a new `Fife::Pipe` instance.

It has 2 forms of usage:

1.  pass an operation as the argument
`Fife(io_ary).pipe(->io{io})`
2.  pass the underscored name of an operation class,
and 0 or more arguments as the constructor arguments of that class.
`Fife(io_ary).pipe(:store, my_storage)`
see *Define custom operations* for detail.

### Operation

An operation is an object that responds to `call(io)`, and returns 0 or more IO-like objects.
A *lambda* is often used as an operation, but an operation can be of any type.

Currently, `Fife` ships with 4 operations: `:noop`, `:name`, `:store` and `:close`

* noop
Performs no operation on the IO, and returns the IO directly.
* close
Closes the
* store
Stores the content of the IO.
* name
Gives the IO a name according to the per-io naming strategy you specified.
You can retrieve it's name by calling `#name` on the IO instance.
```ruby
name = Fife::Operations::Name.new(->io { 'some_name' })
Fife(io_ary).pipe(name)

# Or
Fife(io_ary).pipe(:name, ->io { 'some_name' })
```

#### Define custom operations

If you feel lambdas are not enough for your job,
you can easily define your own operations.

```ruby
class Fife::Operations::MyOperation
  def initialize(arg1, arg2)
    # Initialize the Operation
  end

  def call(io)
    # Handle the io and return some IO instances
  end
end
```
Then you can use it like
```ruby
Fife(io_ary).pipe(:my_operation, 1, 2)
```

### Storage
To leverage the `:store` operation, you need a *storage*.

A storage is just an object that responds to `store(io)`.

Currently, **Fife** ships with 2 storage classes:

* `Fife::Storage::Null`
Simply does nothing
* `Fife::Storage::Sftp`
Streams the IO to a remote file via SFTP.
This storage should be used with `:name` operation because
the remote filename depends on the name of the IO.
(I know it's nasty, but it's still under developing)

```ruby
storage = Fife::Storage::Sftp.new('localhost', 'me', '/path/to/remote/dir', password: 'P@ssw0rd')
Fife(io_ary).pipe(:store, storage)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aetherus/fife.
