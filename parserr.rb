require 'curb'
require 'nokogiri'
require 'csv'

url = ARGV.first
file_name =  ARGV.last
html = Curl.get(url)
main_category_page = Nokogiri::HTML(html.body)

all_products_url = main_category_page.xpath("//div/div/link[@itemprop='url']/@href")
all_products_url.each do |product_url|
  html = Curl.get(product_url)
product_page = Nokogiri::HTML(html.body)
 
headers = %w[Название Цена Изображение]

CSV.open("#{file_name}.csv", "a+") do |csv_line|
  csv_line << headers if csv_line.count.zero?
end

product_name = product_page.xpath('//h1[@class="product_main_name"]').text
product_img = product_page.xpath("//div/span/img[@id='bigpic']/@src").text
product_price = product_page.xpath("//span[@class='price_comb']")
product_variant = product_page.xpath("//span[@class='radio_label']")
product_variant.each_with_index do |v , index|
CSV.open("#{file_name}.csv", "a") do |csv_line|

      full_info = ["#{product_name} - #{v&.text}", product_price[index]&.text.to_s, product_img]

      csv_line << full_info
    end
  end
end