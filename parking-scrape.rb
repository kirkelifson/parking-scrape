require 'sqlite3'
require 'nokogiri'
require 'open-uri'

db = SQLite3::Database.new("parking.db")

#db.execute <<SQL
#create table parking (
#id integer primary key,
#name varchar(40),
#available integer,
#total integer
#)
#SQL

page = Nokogiri::HTML(open("http://secure.parking.ucf.edu/GarageCount/"))

garage_names = []
page.css('table > tr > td.dxgv').each_slice(3) { |a| garage_names << a[0].text }

spaces_available = []
page.css('table > tr > td.dxgv > strong').each { |a| spaces_available << a.text.to_i }

total_spaces = []
page.css('table > tr > td.dxgv').text.split(/[\d]+\/(.*)/).compact.each_slice(2) { |a, b| total_spaces << b }
total_spaces.compact!.map!(&:chomp).map!(&:to_i)

puts "Name\t\tAvailable\tTotal"
garage_names.zip(spaces_available, total_spaces).each do |name, avail, total|
  puts "#{name}\t#{avail}\t\t#{total}"
  db.execute <<SQL
  insert into parking values("#{name}", #{avail}, #{total}, datetime());
SQL
end

