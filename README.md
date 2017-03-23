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
