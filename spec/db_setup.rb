CONFIG = YAML.load_file("#{ROOT}/config/database.yml")

CONFIG.each do |name, uri|
  DataMapper.setup(name, uri)
end

DATABASE_ADAPTER = DataMapper.adapters[:postgres]

MAX_RELATION_SIZE = 10

def setup_db
  DataObjects.logger.set_log('log/do.log', :debug)

  connection = DataObjects::Connection.new(CONFIG['postgres'])

  connection.create_command('DROP TABLE IF EXISTS "users"').execute_non_query
  connection.create_command('DROP TABLE IF EXISTS "addresses"').execute_non_query
  connection.create_command('DROP TABLE IF EXISTS "orders"').execute_non_query
  connection.create_command('DROP TABLE IF EXISTS "songs"').execute_non_query
  connection.create_command('DROP TABLE IF EXISTS "song_tags"').execute_non_query
  connection.create_command('DROP TABLE IF EXISTS "tags"').execute_non_query

  connection.create_command(<<-SQL.gsub(/\s+/, ' ').strip).execute_non_query
    CREATE TABLE "users"
      ( "id"       SERIAL      NOT NULL PRIMARY KEY,
        "username" VARCHAR(50) NOT NULL,
        "age"      SMALLINT    NOT NULL
      )
  SQL

  connection.create_command(<<-SQL.gsub(/\s+/, ' ').strip).execute_non_query
    CREATE TABLE "addresses"
      ( "id"       SERIAL      NOT NULL PRIMARY KEY,
        "user_id"  INTEGER     NOT NULL,
        "street"   VARCHAR(50) NOT NULL,
        "city"     VARCHAR(50) NOT NULL,
        "zipcode"  VARCHAR(10) NOT NULL
      )
  SQL

  connection.create_command(<<-SQL.gsub(/\s+/, ' ').strip).execute_non_query
    CREATE TABLE "orders"
      ( "id"       SERIAL      NOT NULL PRIMARY KEY,
        "user_id"  INTEGER     NOT NULL,
        "product"  VARCHAR(50) NOT NULL
      )
  SQL

  connection.create_command(<<-SQL.gsub(/\s+/, ' ').strip).execute_non_query
    CREATE TABLE "songs"
      ( "id"    SERIAL NOT NULL PRIMARY KEY,
        "title" VARCHAR(50) NOT NULL
      )
  SQL

  connection.create_command(<<-SQL.gsub(/\s+/, ' ').strip).execute_non_query
    CREATE TABLE "tags"
      ( "id"   SERIAL NOT NULL PRIMARY KEY,
        "name" VARCHAR(50) NOT NULL
      )
  SQL

  connection.create_command(<<-SQL.gsub(/\s+/, ' ').strip).execute_non_query
    CREATE TABLE "song_tags"
      ( "id"   SERIAL NOT NULL PRIMARY KEY,
        "song_id" INTEGER NOT NULL,
        "tag_id"  INTEGER NOT NULL
      )
  SQL

  connection.close
end

def seed
  connection = DataObjects::Connection.new(CONFIG['postgres'])
  MAX_RELATION_SIZE.times { |n| insert_user(n + 1, Randgen.name, n*3, connection) }
  connection.close
end

def insert_user(id, name, age, connection = nil)
  connection ||= DataObjects::Connection.new(CONFIG['postgres'])

  insert_users = connection.create_command(
    'INSERT INTO "users" ("id", "username", "age") VALUES (?, ?, ?)')

  insert_users.execute_non_query(id, name, age)

  connection.close
end

def insert_address(id, user_id, street, city, zipcode, connection = nil)
  connection ||= DataObjects::Connection.new(CONFIG['postgres'])

  insert_users = connection.create_command(
    'INSERT INTO "addresses" ("id", "user_id", "street", "city", "zipcode") VALUES (?, ?, ?, ?, ?)')

  insert_users.execute_non_query(id, user_id, street, city, zipcode)

  connection.close
end

def insert_order(id, user_id, product, connection = nil)
  connection ||= DataObjects::Connection.new(CONFIG['postgres'])

  insert_users = connection.create_command(
    'INSERT INTO "orders" ("id", "user_id", "product") VALUES (?, ?, ?)')

  insert_users.execute_non_query(id, user_id, product)

  connection.close
end

def insert_song(id, title, connection = nil)
  connection ||= DataObjects::Connection.new(CONFIG['postgres'])

  insert_users = connection.create_command(
    'INSERT INTO "songs" ("id", "title") VALUES (?, ?)')

  insert_users.execute_non_query(id, title)

  connection.close
end

def insert_tag(id, name, connection = nil)
  connection ||= DataObjects::Connection.new(CONFIG['postgres'])

  insert_users = connection.create_command(
    'INSERT INTO "tags" ("id", "name") VALUES (?, ?)')

  insert_users.execute_non_query(id, name)

  connection.close
end

def insert_song_tag(id, song_id, tag_id, connection = nil)
  connection ||= DataObjects::Connection.new(CONFIG['postgres'])

  insert_users = connection.create_command(
    'INSERT INTO "song_tags" ("id", "song_id", "tag_id") VALUES (?, ?, ?)')

  insert_users.execute_non_query(id, song_id, tag_id)

  connection.close
end
