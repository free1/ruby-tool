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
	# validates :original_site_id, :uniqueness => true
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

class Brand2 < ActiveRecord::Base
	self.table_name = 'brands'

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

Product1.find_each.each do |product1|
	product2 = Product2.new
	product2.title = product1.name
	product2.source_site = product1.item_url
	# product2.description = product1.description
	product2.thumb_image_path = product1.image_url.split(";").first if product1.image_url.present?
	# product2.thumb_image = product1.
	product2.watch_count = 0
	product2.status = 1

	# product1.product_details1.find_each do |product_details1|
		# product2 = Product2.where(original_site_id: product1.origin_id).first
		product_details2 = product2.product_details2.build
		product_details2.gender_id = product1.gender_id
		product_details2.currency_kind = product1.currency
		product_details2.country = product1.country
		# product_details2.product_id = product1.product_id
		product_details2.store_name = product1.store_name
		product_details2.store_id = product1.store_id
		product_details2.supply = product1.source_site
		product_details2.price = product1.price
		product_details2.price_without_promotion = product1.price_without_promotion
		product_details2.discount = product1.discount
		product_details2.description = product1.description
		product_details2.images_path = product1.image_url
		product_details2.composition = product1.composition
		product_details2.measure = product1.sizeinfo
		product_details2.color = product1.colorinfo
		# product_details2.source_site = "http://www.farfetch.com#{product1.item_url}"
		product_details2.source_site = "#{product1.item_url}"
		product_details2.original_site_id = product1.origin_id

		# brand
		brand2 = Brand2.find_or_create_by(name: product1.brand)
		product2.brand_id = brand2.id

		if product2.save
			p 'product success'
			if product_details2.save
				# category
				category2 = Category2.find_or_create_by(name: product1.categories)
				ProductCategory2.find_or_create_by(product_id: product2.id, secondary_category_id: category2.id)

				p 'product_details success'
			else
				p 'product_details error'
			end
		else
			p 'product error'
		end
	# end
end



