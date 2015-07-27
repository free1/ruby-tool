#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'active_record'


class Brand < ActiveRecord::Base

	db_config = {
		:adapter  => "mysql2",
	  :encoding => 'utf8',
	  # :host     => "ip",
	  :username => "root",
	  :password => "123",
	  :database => "makehave_development"
	}

	establish_connection(db_config)
end

puts "---begin---"

html = open('http://www.farfetch.com/cn/designers-women.aspx?ffref=hd_mnav').read
doc = Nokogiri::HTML(html)

doc.css('#designerGroupWrapper li > a').map do |href|
	puts href.text.strip
	Brand.create(name: href.text.strip)
end