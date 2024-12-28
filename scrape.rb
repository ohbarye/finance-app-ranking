require 'nokogiri'
require 'open-uri'
require 'json'
require 'debug'

def scrape_ios_ranking
  url = "https://apps.apple.com/jp/charts/iphone/%E3%83%95%E3%82%A1%E3%82%A4%E3%83%8A%E3%83%B3%E3%82%B9-apps/6015?chart=top-free"
  html = URI.open(url).read
  doc = Nokogiri::HTML(html)
  items = doc.css('.chart li').map do |item|
    rank = Integer(item.css('.we-lockup__rank').first.text)
    title = item.css('.we-lockup__title').text.strip
    developer = item.css('.we-lockup__subtitle').text.strip
    url = item.css('a').attr('href').value

    {
      rank:,
      title:,
      developer:,
      url:,
    }
  end.sort_by { |item| item[:rank] }

  File.write('ios_ranking.json', JSON.pretty_generate(items))
end

scrape_ios_ranking
