require 'curb'
require 'nokogiri'
require 'csv'

url = ARGV.first
@file_name = ARGV.last

def all_pages(value)
  total_number_prod = value.xpath("//*[@id='amazzing_filter']/div[2]/div[2]/a/span").text
  count_page = (total_number_prod.to_i / 25).ceil
end

def get_html(value)
  html = Curl.get(value)
  main_category_page = Nokogiri::HTML(html.body)
end

def product_parse(value)
  product_name = value.xpath('//h1[@class="product_main_name"]').text
  product_img = value.xpath("//div/span/img[@id='bigpic']/@src").text
  product_price = value.xpath("//span[@class='price_comb']")
  product_variant = value.xpath("//span[@class='radio_label']")
  product_save(product_variant, product_img, product_name, product_price)
end

def product_save(product_variant, product_img, product_name, product_price)
  product_variant.each_with_index do |v, index|
    CSV.open("#{@file_name}.csv", "a") do |csv_line|
      full_info = ["#{product_name} - #{v&.text}", product_price[index]&.text.to_s, product_img]
      csv_line << full_info
    end
  end
end

headers = %w[Название Цена Изображение]

CSV.open("#{@file_name}.csv", "a+") do |csv_line|
  csv_line << headers if csv_line.count.zero?
end

count_pages = all_pages(get_html(url))

(2..count_pages).each do |number_of_page|
  full_source = "#{url}?&p=#{number_of_page}" 
  @full_html = get_html(full_source)
  all_products_url = @full_html.xpath("//div/div/link[@itemprop='url']/@href")
  all_products_url.each do |url|
    product = get_html(url)
    product_parse(product)
  end
end


