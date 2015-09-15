#!/usr/bin/env ruby
require 'active_record'

class Product1 < ActiveRecord::Base
	self.table_name = "products"
	# self.primary_key = "origin_id"
	# has_many :product_details1, class_name: 'ProductDetail1', foreign_key: 'product_id'
	# has_many :product_categories1, class_name: 'ProductCategory1', foreign_key: 'origin_id'
	# has_many :categories1, through: :product_categories1

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
	validates :title, :uniqueness => true
	validates :brand_id, presence: true
	has_many :product_details2, class_name: 'ProductDetail2', foreign_key: 'product_id'

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

class ProductDetail2 < ActiveRecord::Base
	self.table_name = 'product_details'

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

class Brand2 < ActiveRecord::Base
	self.table_name = 'brands'

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

class ProductCategory2 < ActiveRecord::Base
	self.table_name = 'product_secondary_categories'

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

class Category2 < ActiveRecord::Base
	self.table_name = 'secondary_categories'
	belongs_to :product

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

# 5 张表 
Product1.find_each do |product1|
	product_detail2 = ProductDetail2.where(source_site: product1.item_url).last
	p product1
	p "====================="
	p product_detail2
	product_detail2.update(remote_data_id: product1.id, remote_categories: product1.categories)
end





