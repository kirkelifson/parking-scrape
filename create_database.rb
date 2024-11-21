require 'pg'
require 'dotenv'

db_name = ENV.fetch('DB_NAME', 'parking')
db_user = ENV.fetch('DB_USER', 'parking')
db_password = ENV.fetch('DB_PASSWORD', nil)

Dotenv.load

begin
  con = PG.connect host: 'localhost', dbname: db_name, user: db_user, password: db_password
  sql = "
  CREATE TABLE
    parking(
      id serial primary key,
      name varchar(40) not null,
      available integer not null,
      total integer not null,
      created_at timestamp
    )
  "
  con.exec(sql)
rescue PG::Error => e
  puts e.message
ensure
  con&.close
end
