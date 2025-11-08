require 'nokogiri'
require 'open-uri'
require 'json'
require 'debug'

def scrape_ios_ranking
  url = "https://apps.apple.com/jp/charts/iphone/%E3%83%95%E3%82%A1%E3%82%A4%E3%83%8A%E3%83%B3%E3%82%B9-apps/6015?chart=top-free"
  html = URI.open(url).read
  doc = Nokogiri::HTML(html)
  items = doc.css('.shelf .grid li').map do |item|
    rank = Integer(item.css('.ordinal').first.text)
    title = item.css('h3').text.strip
    # Developer is not available in the current HTML structure
    # developer = item.css('.we-lockup__subtitle').text.strip
    url = item.css('a').attr('href').value

    {
      rank:,
      title:,
      url:,
    }
  end.sort_by { |item| item[:rank] }

  prev_items = JSON.parse(File.read('ios_ranking.json'), symbolize_names: true)
  app_id = 'id1487752024'
  prev_rank = prev_items.find { |item| item[:url].include?(app_id) }&.fetch(:rank) || "out of ranking"
  new_rank = items.find { |item| item[:url].include?(app_id) }&.fetch(:rank) || "out of ranking"

  # This diff will be passed to the next step of GitHub Actions as $GITHUB_OUTPUT
  emoji = new_rank < prev_rank ? '🔼' : new_rank > prev_rank ? '🔽' : '🔵'
  puts "ios_diff='iOS: #{prev_rank} -> #{new_rank} #{emoji}'"

  File.write('ios_ranking.json', JSON.pretty_generate(items))
end

scrape_ios_ranking
