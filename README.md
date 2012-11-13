# The Mapper for DataMapper 2

[![Build Status](https://secure.travis-ci.org/solnic/dm-mapper.png)](http://travis-ci.org/solnic/dm-mapper)

The mapper supports mapping data from any data source into Ruby objects based on
mapper definitions. It uses engines that implement common interface for CRUD
operations.

## Mapper Engines

In the most simple case a bare-bone mapper engine needs to provide a relation
object that has a name and implements `#each` which yields objects that respond
to `#[]`. That's the minimum contract.

Here's an example of an in-memory engine which uses an `Array` subclass for the
relation object and `Hash` as the class for the yielded objects.

Since `Array` implements `#each` and `Hash` implements `#[]` we've got all we need:

``` ruby
class MemoryEngine < DataMapper::Engine

  class Relation < Array
    attr_reader :name

    def initialize(name)
      @name = name
    end
  end

  def base_relation(name, header = nil)
    Relation.new(name)
  end
end

DataMapper.engines[:memory] = MemoryEngine.new

User = Class.new(OpenStruct)

class UserMapper < DataMapper::Mapper::Relation
  repository    :memory
  relation_name :users
  model         User

  map :name, String,  :to => :UserName
  map :age,  Integer, :to => :UserAge
end

DataMapper.finalize

mapper = DataMapper[User]

mapper.relations[:users] << { :UserName => 'Piotr', :UserAge => 29 }

mapper.to_a
# [#<User name="Piotr", age=29>]
```

DataMapper 2 will come with support for [Veritas](https://github.com/dkubb/veritas)
and [ARel](https://github.com/rails/arel) engines.

Veritas is a polyglot relational algebra library which will give us ability to
talk to different data sources and even performing cross-database joins whereas
ARel will only give you support for RDBMS.

## Establishing Connection & Defining PORO with mappers

``` ruby
# Setup db connection
DataMapper.setup(:postgres, "postgres://localhost/test")

# Define a PORO
class User
  attr_reader :id, :name

  def initialize(attributes)
    @id, @name = attributes.values_at(:id, :name)
  end
end

# Define a mapper
class Mapper < DataMapper::Mapper::Relation

  model         User
  relation_name :users
  repository    :postgres

  map :id,   Integer, :key => true
  map :name, String,  :to => :username
end

# Finalize setup
DataMapper.finalize
```

## Defining relationships

``` ruby
class Order
  attr_reader :id, :product

  def initialize(attributes)
    @id, @product = attributes.values_at(:id, :product)
  end
end

class User
  attr_reader :id, :name, :age, :orders, :apple_orders

  def initialize(attributes)
    @id, @name, @age, @orders, @apple_orders = attributes.values_at(
      :id, :name, :age, :orders, :apple_orders
    )
  end
end

class OrderMapper < DataMapper::Mapper::Relation
  model         Order
  relation_name :orders
  repository    :postgres

  map :id,      Integer, :key => true
  map :user_id, Integer
  map :product, String
end

class UserMapper < DataMapper::Mapper::Relation
  model         User
  relation_name :users
  repository    :postgres

  map :id,     Integer, :key => true
  map :name,   String,  :to => :username
  map :age,    Integer

  has 0..n, :orders, Order

  has 0..n, :apple_orders, Order do
    restrict { |r| r.order_product.eq('Apple') }
  end
end

# Find all users and eager-load their orders
DataMapper[User].include(:orders).to_a

# Find all users and eager-load restricted apple_orders
DataMapper[User].include(:apple_orders).to_a
```

## Model Extension and Generating Mappers

To simplify the process of defining mappers you can extend your PORO with a small
extension (which uses `Virtus` under the hood) and specify only special mapping
cases:

``` ruby
class Order
  include DataMapper::Model

  attribute :id,      Integer
  attribute :product, String
end

class User
  include DataMapper::Model

  attribute :id,     Integer
  attribute :name,   String
  attribute :age,    Integer
  attribute :orders, Array[Order]
end

DataMapper.build(Order, :postgres) do
  key :id
end

DataMapper.build(User, :postgres) do
  key :id

  map :name, :to => :username

  has 0..n, :orders, Order
end

DataMapper.finalize

# ...and you're ready to go :)
DataMapper[User].include(:orders).to_a
```

## Finding Objects

Mappers come with a simple high-level query API similar to what you know from other Ruby ORMS:

```ruby
# Find all users matching criteria
DataMapper[User].find(:age => 21)

# Find and sort users
DataMapper[User].find(:age => 21).order(:name, :age)

# Get one object matching criteria
DataMapper[User].one(:name => 'Piotr')
```

## Low-level API using underlying relations

You can interact with the underlying relations if you want. A more "user friendly"
API will be built on top of that.

Mappers are enumerables so it should feel natural when working with them.

```ruby
# Grab the user mapper instance and have fun
user_mapper = DataMapper[User]

# Get them all
user_mapper.to_a

# Iterate on all users
user_mapper.each { |user| puts user.name }

# Restrict
user_mapper.restrict { |relation| relation.name.eq('John') }.to_a

# Sort by
user_mapper.sort_by { |r| [ r.name, r.id ] }.to_a
```

## 2.0.0.alpha Roadmap

 * Refactor relation registry using metrics (improve test coverage too)
 * Add interface for insert/update/delete to relation graph
 * Implement ARel engine (this will support full CRUD)
 * Finish Veritas engine
 * Push a release? :)
