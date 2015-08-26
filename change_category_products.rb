#!/usr/bin/env ruby
require 'active_record'

class Product1 < ActiveRecord::Base
	self.table_name = "products"
	# self.primary_key = "origin_id"
	# has_many :product_details1, class_name: 'ProductDetail1', foreign_key: 'product_id'
	has_many :product_categories1, class_name: 'ProductCategory1', foreign_key: 'product_id'
	has_many :categories1, through: :product_categories1

	db1_config = {
	:adapter  => "mysql2",
	  :encoding => 'utf8',
	  :host     => "54.223.188.18",
	  :username => "root",
	  :password => "password",
	  :database => "makehave"
	}

	establish_connection(db1_config)
end

class Category1 < ActiveRecord::Base
	self.table_name = 'categories'

	db1_config = {
		:adapter  => "mysql2",
	  :encoding => 'utf8',
	  :host     => "54.223.188.18",
	  :username => "root",
	  :password => "password",
	  :database => "makehave"
	}

	establish_connection(db1_config)
end

class ProductCategory1 < ActiveRecord::Base
	self.table_name = 'product_categories'
	belongs_to :product1, class_name: 'Product1', foreign_key: 'origin_id'
	belongs_to :categories1, class_name: 'Category1', foreign_key: 'category_id'

	db1_config = {
		:adapter  => "mysql2",
	  :encoding => 'utf8',
	  :host     => "54.223.188.18",
	  :username => "root",
	  :password => "password",
	  :database => "makehave"
	}

	establish_connection(db1_config)
end

class Product2 < ActiveRecord::Base
	self.table_name = "products"
	validates :original_site_id, :uniqueness => true

	db2_config = {
		:adapter  => "mysql2",
	  :encoding => 'utf8',
	  :host     => "localhost",
	  :username => "root",
	  :password => "123",
	  :database => "makehave_development"
	}

	establish_connection(db2_config)
end

class Category2 < ActiveRecord::Base
	self.table_name = 'secondary_categories'
	belongs_to :product

	db2_config = {
		:adapter  => "mysql2",
	  :encoding => 'utf8',
	  :host     => "localhost",
	  :username => "root",
	  :password => "123",
	  :database => "makehave_development"
	}

	establish_connection(db2_config)
end

class ProductCategory2 < ActiveRecord::Base
	self.table_name = 'product_secondary_categories'

	db2_config = {
		:adapter  => "mysql2",
	  :encoding => 'utf8',
	  :host     => "localhost",
	  :username => "root",
	  :password => "123",
	  :database => "makehave_development"
	}

	establish_connection(db2_config)
end

Product1.find_each.each do |product1|
	p "=======s=ss=s=s=s=s=s"
	p product1.item_url
	p product1.categories1

	product1.categories1.each do |category1|
		product2 = Product2.where(original_site_id: product1.origin_id).first
		category2 = Category2.find_or_create_by(name: category1.name)
		ProductCategory2.find_or_create_by(product_id: product2.id, secondary_category_id: category2.id)
		p "success"
	end
end