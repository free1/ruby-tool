File.open('result.csv').each do |line|
  # print "#{line_num += 1} #{line}"
  file_product = JSON.parse(line)
  product = Product.find(file_product["id"])
  product.update(Cate1Name: file_product["Cate1Name"], Cate2Name: file_product["Cate2Name"], Cate3Name: file_product["Cate3Name"], match_key: file_product["MatchKey"])
end

HotSearch.find_each do |hot_search|
  f = open("hot_search.json", 'a')
  f.write(hot_search.as_json)
  f.write("\n")
  f.close
end

Brand.find_each do |brand|
  f = open("brands.json", 'a')
  f.write(brand.name)
  f.write("\n")
  f.close
end

Brand.find_each do |brand|
  f = open("brands_name.txt", 'a')
  f.write(brand.name)
  f.write("\n")
  f.close
end

File.open("#{Rails.root}/brands.txt",'w') do |f|
  Brand.find_each do |brand|
    f.write(brand.name)
    f.write("\n")
  end
end

File.open("products",'w') do |f|
  Product.find_each do |product|
    f.write(product.as_indexed_json)
    f.write("\n")
  end
end

Product.find_each do |product|
  p "--------#{product.id}--------------"
  f = open("products.json", 'a')
  f.write(product.to_json)
  f.write("\n")
  f.close
end

# 商品输出josn
Product.where(Cate1Name: "女装").limit(10000).find_each do |product|
  f = open("result_bag_products.json", 'a')
  f.write(product.as_json(only: [:id, :title, :temporary_brand, :item_url], methods: :thumb_image_url).to_json)
  f.write(",")
  f.write("\n")
  f.close
end

# 转换json到csv
require 'csv'
csv_string = CSV.generate do |csv|
  JSON.parse(File.open("result_bag_products.json").read).each do |hash|
    CSV.open("result_clothes_products.csv", "a") do |csv|
      csv << hash.values
    end
  end
end

File.open('translate.csv').each do |line|
  # print "#{line_num += 1} #{line}"
  file_product = JSON.parse(line)
  product = Product.find(file_product["id"])
  product.update(title_cn: file_product["title_cn"])
end

File.open('brands.txt').each do |line|
  brand = Brand.where(name: line.chomp).first
  if brand.present?
    brand.update(published: true)
  end
end

# if file_product["Cate1Name"].present?
  #   category = MultilevelCategory.where(cn_name: file_product["Cate1Name"].last.force_encoding("utf-8")).last
  #   product.multilevel_categories << category
  # end