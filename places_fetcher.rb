require 'csv'
require 'google_places'

## requirements
@locations_file = ARGV.fetch(0) do
  raise(
    StandardError::ArgumentError,
    'You must provide locations CSV file with lat / lng in col[1] and col[2] respectivly.'
  )
end

@query = ARGV.fetch(1) do
  raise(
    StandardError::ArgumentError,
    'You must provide query string to search places for.'
  )
end

# variables
@client = nil # google_places client instance
@api_key = nil # Google API key
@places = Hash.new # places hash

def perform_query(&block)
  results = nil
  while results == nil do
    begin
      results = yield block
    rescue GooglePlaces::OverQueryLimitError, GooglePlaces::RequestDeniedError
      puts 'Api Key Invalidated. Provide new Api Key:'
      @api_key = STDIN.gets
      @client = GooglePlaces::Client.new(@api_key)
    end
  end
  results
end

# script
puts 'Google Api Key:'
@api_key = STDIN.gets

@client = GooglePlaces::Client.new(@api_key)

CSV.foreach(@locations_file) do |row|
  puts "Processing city: #{row[0]}"
  results = perform_query do
    @client.spots_by_query(@query, lat: row[1], lng: row[2], radius: 20000, multipage: true)
  end
  results.each do |spot|
    @places[spot.place_id] = { lat: spot.lat, lng: spot.lng, name: spot.name, uuid: spot.id, city_query: row[0] }
  end
  sleep 0.5
end

CSV.open('results.csv', 'w') do |csv|
  @places.each do |key, value|
    puts "Processing company: #{value[:name]} (at #{value[:city_query]})"
    result = perform_query do
      @client.spot(key)
    end
    csv << [key, value[:name], value[:lat], value[:lng], value[:uuid], result.website, result.url, value[:city_query]]
    sleep 0.5
  end
end
