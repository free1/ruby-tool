#!/usr/bin/env ruby
require 'active_record'

class Product < ActiveRecord::Base
	has_many :product_details

	db2_config = {
		:adapter  => "mysql2",
	  :encoding => 'utf8',
	  :host     => "localhost",
	  :username => "root",
	  :password => "123",
	  :database => "makehave_production"
	}

	establish_connection(db2_config)
end

class ProductDetail < ActiveRecord::Base

	db2_config = {
		:adapter  => "mysql2",
	  :encoding => 'utf8',
	  :host     => "localhost",
	  :username => "root",
	  :password => "123",
	  :database => "makehave_production"
	}

	establish_connection(db2_config)
end


Product.all.each do |product|
	pd= product.product_details.first.as_json
	p = product.as_json
	p.merge! pd
	f = File.open("product_file_json", "aw")
	f.write(p)
	f.write("\n")
	f.close
	# File.open("/product_file_json", 'w') { |file| file.write(p) }
end


