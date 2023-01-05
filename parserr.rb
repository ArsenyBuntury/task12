require 'curb'
require 'nokogiri'
require 'csv'

url = "https://www.petsonic.com/farmacia-para-gatos/"
html = Curl.get(url)
main_category_page = Nokogiri::HTML(html.body)
all_products_url = main_category_page.xpath("//div/div/link[@itemprop='url']/@href")



CSV.open('parsed.csv', "a") do |csv_line|
  csv_line << ['Название', 'Весовка', 'Цена']

  
  all_products_url.each do |product_url|
    html = Curl.get(product_url)
    product_page = Nokogiri::HTML(html.body)
    product_name = product_page.xpath('//h1[@class="product_main_name"]').text
    attribute_product_list = product_page.xpath('//div[@class="attribute_list"]')
    attribute_product_list.each do |attr|
      product_variant = product_page.xpath('//span[@class="radio_label"]').text

      product_price = product_page.xpath('//span[@class="price_comb"]').text
      full_info = ["#{product_name}, #{product_variant}, #{product_price}"]

      csv_line << full_info
    end

  end
end