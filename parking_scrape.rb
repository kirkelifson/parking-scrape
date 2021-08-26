require 'dotenv'
require 'logger'
require 'nokogiri'
require 'open-uri'
require 'pg'

logger = Logger.new($stdout)
logger.level = Logger::WARN

Dotenv.load

page = Nokogiri::HTML(URI.open('http://secure.parking.ucf.edu/GarageCount/'))

rows = page.css('table > tr > td.dxgv')

garage_names = []
rows.each_slice(3) { |a| garage_names << a[0].text }

spaces_available = []
rows.css('strong').each { |a| spaces_available << a.text.to_i }

total_spaces = []
spaces = rows.text.split(%r{\d+/(.*)}).compact
spaces.each_slice(2) { |_a, b| total_spaces << b }
total_spaces.compact.map(&:chomp).map!(&:to_i)

logger.debug "Name\t\tAvailable\tTotal"

begin
  con = PG.connect host: 'localhost', user: 'parking', password: ENV['DB_PASSWORD'], dbname: 'parking'
  garage_names.zip(spaces_available, total_spaces).each do |name, avail, total|
    logger.debug "#{name}\t#{avail}\t\t#{total}"
    sql = "
      INSERT INTO
        parking(name, available, total, created_at)
      VALUES('#{name}', '#{avail}', '#{total}', current_timestamp)
    "
    con.exec(sql)
  end
rescue PG::Error => e
  logger.warn e.message
ensure
  con&.close
end
