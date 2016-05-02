# 分类导入
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


# 品牌
File.open("brands.json", "r").each do |f|
	file_product = JSON.parse(f)

	# 创建商品
	product = Product.new
	product.title = file_product["name"]
	product.thumb_image_path = file_product["thumbimages"]
	product.watch_count = 0
	product.status = 1
	product.item_url = file_product["item_url"]
	product.temporary_brand = file_product["brand"]
	product.origin_id = file_product["origin_id"]
	product.gender_id = file_product["gender_id"]
	product.country = file_product["country"]
	product.currency = file_product["currency"]
	product.store_name = file_product["store_name"]
	product.store_id = file_product["store_id"]
	product.price = file_product["price"]
	product.price_without_promotion = file_product["price_without_promotion"]
	product.discount = file_product["discount"]
	product.description = file_product["description"]
	product.images_path = file_product["image_url"]
	product.composition = file_product["composition"]
	product.shipping = file_product["shipping"]
	product.colorinfo = file_product["colorinfo"]
	product.sizeinfo = file_product["sizeinfo"]
	product.supply = file_product["source_site"]
	product.temporary_categories = file_product["categories"]

	# 详情		
	product_details2 = product.product_details.build
	product_details2.gender_id = file_product["gender_id"]
	product_details2.currency_kind = file_product["currency"]
	product_details2.country = file_product["country"]
	product_details2.store_name = file_product["store_name"]
	product_details2.store_id = file_product["store_id"]
	product_details2.supply = file_product["source_site"]
	product_details2.price = file_product["price"]
	product_details2.price_without_promotion = file_product["price_without_promotion"]
	product_details2.discount = file_product["discount"]
	product_details2.description = file_product["description"]
	product_details2.images_path = file_product["image_url"]
	product_details2.composition = file_product["composition"]
	product_details2.measure = file_product["sizeinfo"]
	product_details2.color = file_product["colorinfo"]
	product_details2.source_site = file_product["item_url"]
	product_details2.original_site_id = file_product["origin_id"]

	# brand
	brand = Brand.find_or_create_by(name: file_product["brand"])
	product.brand_id = brand.id

	product.product_detail_id = 0

	if product_details2.save
		p 'product_detail success'
		product.product_detail_id = product_details2.id
		if product.save
			# category
			# if product1.categories.present?
			# 	product1.categories.split(",").each do |category|
			# 		category2 = Category2.find_or_create_by(name: category)
			# 		ProductCategory2.find_or_create_by(product_id: product2.id, secondary_category_id: category2.id)
			# 	end
			# end

			# 加入经典款
			Tag.where(name: "经典款").last.products << product

			p 'product_details success'
		else
			p 'product_details error'
		end
	else
		p 'product error'
	end
end


