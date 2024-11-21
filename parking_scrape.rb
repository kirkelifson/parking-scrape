require 'ferrum'
require 'dotenv'
require 'logger'
require 'nokogiri'
require 'open-uri'
require 'pg'
require 'debug'

USER_AGENT = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36'.freeze

log_level = ENV['LOG_LEVEL'] || 'warn'
db_host = ENV.fetch('DB_HOST', 'localhost')
db_user = ENV.fetch('DB_USER', 'parking')
db_password = ENV.fetch('DB_PASSWORD', nil)
db_name = ENV.fetch('DB_NAME', 'parking')
url = ENV.fetch('URL', 'https://parking.ucf.edu/resources/garage-availability/')

logger = Logger.new($stdout)
logger.level = Kernel.const_get("Logger::#{log_level.upcase}")

Dotenv.load

browser = Ferrum::Browser.new
page = browser.create_page
page.headers.set({ 'User-Agent' => USER_AGENT })
page.go_to(url)
body = Nokogiri::HTML5(page.body)
browser.quit

rows = body.css('table > tbody > tr')

results = rows.map do |row|
  row.css('td').map(&:text)
end

logger.debug "Name\t\tAvailable\tTotal"

begin
  con = PG.connect host: db_host, user: db_user, password: db_password, dbname: db_name
  results.each do |name, avail, total, _|
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
