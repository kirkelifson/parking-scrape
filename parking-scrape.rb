require 'pg'
require 'nokogiri'
require 'open-uri'
require 'dotenv'

Dotenv.load

page = Nokogiri::HTML(open("http://secure.parking.ucf.edu/GarageCount/"))

garage_names = []
page.css('table > tr > td.dxgv').each_slice(3) { |a| garage_names << a[0].text }

spaces_available = []
page.css('table > tr > td.dxgv > strong').each { |a| spaces_available << a.text.to_i }

total_spaces = []
page.css('table > tr > td.dxgv').text.split(/[\d]+\/(.*)/).compact.each_slice(2) { |a, b| total_spaces << b }
total_spaces.compact.map(&:chomp).map!(&:to_i)

puts "Name\t\tAvailable\tTotal"

begin
  con = PG.connect host: 'localhost', user: 'parking', password: ENV['DB_PASSWORD'], dbname: 'parking'
  garage_names.zip(spaces_available, total_spaces).each do |name, avail, total|
    puts "#{name}\t#{avail}\t\t#{total}"
    con.exec("INSERT INTO parking (name, available, total, created_at) VALUES('#{name}', #{avail}, #{total}, current_timestamp)")
  end
rescue PG::Error => e
  puts e.message
ensure
  con.close if con
end
