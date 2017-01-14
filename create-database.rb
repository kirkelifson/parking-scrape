require 'pg'
require 'dotenv'

Dotenv.load

begin
  con = PG.connect host: 'localhost', dbname: 'parking', user: 'parking', password: ENV['DB_PASSWORD']
  con.exec "CREATE TABLE parking(id INTEGER PRIMARY KEY, name varchar(40) not null, available integer not null, total integer not null)";
rescue PG::Error => e
  puts e.message
ensure
  con.close if con
end
