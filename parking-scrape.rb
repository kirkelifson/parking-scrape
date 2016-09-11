require 'sqlite3'
require 'nokogiri'
require 'open-uri'

#create table parking (
#id integer primary key,
#name varchar(40),
#available integer,
#total integer
#)

page = Nokogiri::HTML(open("http://secure.parking.ucf.edu/GarageCount/"))

garage_names = []
page.css('table > tr > td.dxgv').each_slice(3) { |a| garage_names << a[0].text }

spaces_available = []
page.css('table > tr > td.dxgv > strong').each { |a| spaces_available << a.text.to_i }

total_spaces = []
page.css('table > tr > td.dxgv').text.split(/[\d]+\/(.*)/).compact.each_slice(2) { |a, b| total_spaces << b }
total_spaces.compact!.map!(&:chomp).map!(&:to_i)

puts "Name\t\tAvailable\tTotal"
SQLite3::Database.new("/var/www/parking-scrape/parking.db") do |db|
  garage_names.zip(spaces_available, total_spaces).each do |name, avail, total|
    puts "#{name}\t#{avail}\t\t#{total}"
    db.execute("insert into parking values('#{name}', #{avail}, #{total}, datetime())")
  end
end
