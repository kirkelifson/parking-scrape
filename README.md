# parking-scrape

A ruby script that parses UCF's [parking statistics](http://secure.parking.ucf.edu/GarageCount/).

## Usage

* Must have postgresql installed and running.

```bash
rvm install 2.3.3
git clone https://github.com/kirkelifson/parking-scrape.git
cd parking-scrape
gem install bundler
bundle install
ruby create-database.rb
ruby parking-scrape.rb
```

Example data:

```
andromeda ~/parking-scrape master $ DB_PASSWORD=xxx ruby /home/xtc/parking-scrape/parking-scrape.rb
Name         Available    Total
Garage A     0            1623
Garage B     1105         1259
Garage C     1849         1852
Garage D     1237         1241
Garage H     1284         1284
Garage I     1242         1231
Garage Libra 677          1007
```
