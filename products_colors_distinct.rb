colors = []
ProductDetail.find_each do |product|
# ProductDetail.limit(100).each do |product|
  begin
    product.color.each do |c|
      unless colors.include?(c["color"])
        colors << c["color"] 
      end
    end
    if product.id == 300000 || product.id == 370000
      f = open("colors.txt", 'a')
      f.write(colors)
      f.write("\n")
      f.close
    end
  ensure
    next
  end
end