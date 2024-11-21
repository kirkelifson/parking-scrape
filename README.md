# parking-scrape

A ruby script that parses UCF's [parking statistics](http://secure.parking.ucf.edu/GarageCount/).

## Usage

* Must have postgresql installed and running, and a browser installed.
* Override DB_USER, DB_PASSWORD, DH_HOST, and DB_NAME as needed.

```bash
apt install chromium
rvm install 3.3.6
git clone https://github.com/kirkelifson/parking-scrape.git
cd parking-scrape
gem install bundler
bundle install
ruby create-database.rb
ruby parking-scrape.rb
```

Example debug output:

```
% LOG_LEVEL=debug ruby parking_scrape.rb
D, [2024-11-20T22:36:42.792057 #2275135] DEBUG -- : Name		Available	Total
D, [2024-11-20T22:36:42.814712 #2275135] DEBUG -- : Garage A	1411		1647
D, [2024-11-20T22:36:42.816934 #2275135] DEBUG -- : Garage B	1289		1289
D, [2024-11-20T22:36:42.817739 #2275135] DEBUG -- : Garage C	498		1848
D, [2024-11-20T22:36:42.818679 #2275135] DEBUG -- : Garage D	789		1289
D, [2024-11-20T22:36:42.819378 #2275135] DEBUG -- : Garage H	1331		1331
D, [2024-11-20T22:36:42.819983 #2275135] DEBUG -- : Garage I	1270		1270
```
