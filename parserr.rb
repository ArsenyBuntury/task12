require 'open-uri'
require 'nokogiri'
require 'csv'


main_category_page = Nokogiri::HTML(URI.open('https://www.petsonic.com/farmacia-para-gatos/'))


all_products_url = []


main_category_page.each do |product|
  
  @all_products_url << product.xpath('//link[@itemprop="url"]/@href')
  
  
  
end


CSV.open('parsed.txt', "wb") do |csv_line|
  csv_line << ['Название', 'Весовка', 'Цена']

  
  all_products_url.each do |product_url|
    product_page = Nokogiri::HTML(open(product_url))
    product_name = product_page.xpath('//h1[@class="product_main_name"]').to_s
    attribute_product_list = product_page.xpath('//div[@class="attribute_list"]')
    binding.pry
    attribute_product_list.each do |attr|
      product_variant = product_page.xpath('//span[@class="radio_label"]')

      product_price = product_page.xpath('//span[@class="price_comb"]')
      full_info = ["#{product_name}, #{product_variant}, #{product_price}"]

      csv_line << full_info
    end

  end
end