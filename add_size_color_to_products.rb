#!/usr/bin/env ruby
require 'active_record'

class Product1 < ActiveRecord::Base
	self.table_name = "products"
	# self.primary_key = "origin_id"
	has_many :product_details1, class_name: 'ProductDetail1', foreign_key: 'product_id'
	has_many :product_categories1, class_name: 'ProductCategory1', foreign_key: 'origin_id'
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

class ProductDetail1 < ActiveRecord::Base
	self.table_name = 'product_details'
	belongs_to :product

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
	has_many :product_details2, class_name: 'ProductDetail2', foreign_key: 'product_id'

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

class ProductDetail2 < ActiveRecord::Base
	self.table_name = 'product_details'

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
	self.table_name = 'product_categories'

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
	self.table_name = 'categories'
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

class Brand < ActiveRecord::Base

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

# size, color
# Product1.find_each.each do |product1|

# 	product1.product_details1.find_each do |product_details1|
# 		product2 = Product2.where(original_site_id: product1.origin_id).first
# 		if product2.present?
# 			product_details2 = product2.product_details2.first

# 			if product_details2.present?
# 				product_details2.measure = product_details1.size
# 				product_details2.color = product_details1.color

# 				if product_details2.save
# 					p 'product_details success'
# 				else
# 					p 'product_details error'
# 				end
# 			end
# 		end

# 	end
# end

# brand
Product1.find_each do |product1|

	brand = Brand.where(name: product1.designer_name).first
	if brand.present?
		product2 = Product2.where(original_site_id: product1.origin_id).first
		p product2
		if product2.present?
			product2.update_column(:brand_id, brand.id)
			p "success"
		else
			p "error"
		end
	else
		p "404------"
	end

end