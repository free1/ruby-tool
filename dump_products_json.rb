#!/usr/bin/env ruby
require 'active_record'

class Product < ActiveRecord::Base

  db1_config = {
    :adapter  => "mysql2",
    :encoding => 'utf8',
    :host     => "localhost",
    :username => "root",
    :password => "123",
    :database => "makehave_development"
  }

  establish_connection(db1_config)
end

Product.find_each do |product|
  f = open("products_result.json", 'wb')
  f.write(product.as_json)
  f.write("\n")
  f.close
end