# -*- encoding: utf-8 -*-
# stub: geoip 1.6.3 ruby lib

Gem::Specification.new do |s|
  s.name = "geoip".freeze
  s.version = "1.6.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Clifford Heath".freeze, "Roland Moriz".freeze]
  s.date = "2017-01-07"
  s.description = "GeoIP searches a GeoIP database for a given host or IP address, and\nreturns information about the country where the IP address is allocated,\nand the city, ISP and other information, if you have that database version.".freeze
  s.email = ["clifford.heath@gmail.com".freeze, "rmoriz@gmail.com".freeze]
  s.executables = ["geoip".freeze]
  s.extra_rdoc_files = ["LICENSE".freeze, "README.rdoc".freeze]
  s.files = ["LICENSE".freeze, "README.rdoc".freeze, "bin/geoip".freeze]
  s.homepage = "http://github.com/cjheath/geoip".freeze
  s.licenses = ["LGPL".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "GeoIP searches a GeoIP database for a given host or IP address, and returns information about the country where the IP address is allocated, and the city, ISP and other information, if you have that database version.".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version
end
