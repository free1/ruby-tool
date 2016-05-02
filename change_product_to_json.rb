#!/usr/bin/env ruby
require 'active_record'

class Product < ActiveRecord::Base
	has_many :product_details
	has_many :product_secondary_categories
 	has_many :secondary_categories, through: :product_secondary_categories

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

class SecondaryCategory < ActiveRecord::Base
end

class ProductSecondaryCategory < ActiveRecord::Base
	belongs_to :product
	belongs_to :secondary_category
end

# f = File.open("product_file_json", "a")
# Product.all.each do |product|
# 	pd= product.product_details.first.as_json
# 	p = product.as_json
# 	p.merge! pd
# 	cate = product.secondary_categories.map(&:name) if product.secondary_categories.present?
# 	h = {categories: cate}
# 	p.merge! h
# 	f.write(p)
# 	f.write("\n")
# 	f.write("\n")
# 	# File.open("/product_file_json", 'w') { |file| file.write(p) }
# end
# f.close


















# text = File.open('outfile.json').read
# text.each_line do |line|
# 	print "#{line_num += 1} #{line}"
# 	file_product = JSON.parse(line)
# 	product = ProductDetail.find(file_product["id"]).product
# 	if file_product["Cate1Name"].present?
# 		category = Category.where(cn_name: file_product["Cate1Name"].last.force_encoding("utf-8")).last
# 		product.categories << category
# 	end
# end



# categories
File.open("outfile.csv", "r").each do |f|
	begin
		# f = f.read
		# @product_num = 0
		file_product = JSON.parse(f)
		p "-------------------"
		# p file_product

		if file_product["Cate1Name"].present?
			product = ProductDetail.find(file_product["id"]).product
			product.update(Cate1Name: file_product["Cate1Name"].last.force_encoding("utf-8"), Cate2Name: file_product["Cate2Name"].last.force_encoding("utf-8"), Cate3Name: file_product["AliasMatchName"].last.force_encoding("utf-8"))
			category = SecondaryCategory.where(cn_name: file_product["Cate1Name"].last.force_encoding("utf-8")).last
			product.secondary_categories << category if category.present?
			# @product_num += 1			
		end
	ensure
		p "next"
		# p @product_num
		# f.close
	end
end




# append products
File.open("remote_products.json", "r").each do |f|
	begin
		file_product = JSON.parse(f)
		product_detail = ProductDetail.where(source_site: file_product["item_url"]).first
		if product_detail.present?
		 	# 记录远端id
		 	product_detail.update(remote_data_id: file_product["id"], remote_categories: file_product["categories"])
		 	has_product = product_detail.product
		 	# 封面
			if file_product["thumbimages"].present?
				# p "------------thumbimages-------------"
				has_product.update_column(:thumb_image_path, file_product["thumbimages"])
			end
		else
			# 新增商品
			if file_product["item_url"].present? && ProductDetail.where(source_site: file_product["item_url"].last).empty?
				data = {
					title: file_product["name"],
					thumb_image_path: file_product["thumbimages"],
					item_url: file_product["item_url"],
					temporary_brand: file_product["brand"],
					origin_id: file_product["origin_id"],
					gender_id: file_product["gender_id"],
					country: file_product["country"],
					currency: file_product["currency"],
					store_name: file_product["store_name"],
					store_id: file_product["store_id"],
					price: file_product["price"],
					price_without_promotion: file_product["price_without_promotion"],
					discount: file_product["discount"],
					description: file_product["description"],
					images_path: file_product["image_url"],
					composition: file_product["composition"],
					shipping: file_product["shipping"],
					colorinfo: file_product["colorinfo"],
					temporary_categories: file_product["categories"],
				}
				# p "------------------"
				# p data
				product = Product.new(data)
				if product.save
					p "append success"
				else
					p "error"
				end
			end
		end
	ensure
		p "next"
		# p @product_num
		# f.close
	end
end