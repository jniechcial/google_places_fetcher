require 'csv'
require 'geocoder'

Geocoder.configure(
  :lookup => :google,
  :api_key => 'AIzaSyAwiKYh0mvWzj8E-iKsAVV7Hc-KtZNn-RQ',
  :units => :km,
  :use_https => true
)

def parse_result(result)
  return [-1, -1] unless result[0]
  location = result[0].data['geometry']['location']
  [location['lat'], location['lng']]
end

CSV.open('processed_citeis.csv', 'w') do |csv|
  CSV.foreach('cities_list.csv') do |row|
    puts "Parsing city: #{row[0]}"
    result = Geocoder.search(row[0])
    lat, lng = parse_result(result)
    csv << [row[0], lat, lng]
    sleep 0.5
  end
end
