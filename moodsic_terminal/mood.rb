require 'rubygems'
require 'rspotify'
require 'weather-api'

class Spotify
	def initialize(mood)
		@mood = mood
		spotify_client_id = "04a41877bac9440fbc50bc3092fbabcd"
		spotify_client_secret = "77e72f750de845509ba7dccb34102956"
		RSpotify.authenticate(spotify_client_id, spotify_client_secret)
	end

	public
	def recommend()
		recommended_playlist = RSpotify::Playlist.search(@mood)
		puts "Here's the best playlist I found: #{recommended_playlist.first.name}"
		sleep(1)
		recommended_songs = recommended_playlist.first.tracks
		puts "And here's the songs in that playlist: "
		recommended_songs.each{ |track| puts track.name}
	end
end

class WeatherMood
	def initalize
		@weather = "Needham, MA"
		@weather_condition = 0
		@change = "N"
	end

	private
	def weather_lookup(city, state)
		@weather = Weather.lookup_by_location("#{city}, #{state}", Weather::Units::FAHRENHEIT)
		@weather_condition = @weather.condition.code.to_i
		puts "Looking at weather in #{city}, #{state}. Is this correct? (Y/N) "
		@change = gets.chomp.upcase
	end

	private
	def input()
		puts "Which city are you in right now? "
		city = gets.chomp.downcase
		city = city.split.map { |i| i.capitalize }.join(' ')

		puts "Which state are you in right now? (Abbreviated) "
		state = gets.chomp.upcase

		if city.empty? || state.empty?
			puts "Whoops! Didn't catch that. Let's try that again."
			input()
		else
			weather_lookup(city, state)
		end
	end

	public
	def check_input()
		input()

		case @change
			when "Y"
				puts "Great! Finding songs now..."
				set_mood()
			when "N"
				puts "Whoops! Let's try again."
				check_input()
			else
				puts "Error: must select Y or N."
		end
	end

	private
	def set_mood()
    stormy = [0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 15, 17, 18, 35, 37, 41, 43, 45, 46]
    rain = [9, 11, 12, 38, 39, 40, 47]
    snow = [13, 14, 16, 19, 42]
    fog = [20, 21, 22, 23]
    cold = [24, 25]
    sunny = [32, 34, 36]
    cloudy = [26, 27, 28, 29, 30, 44]
    clear = [31, 33]

		if stormy.include? @weather_condition
			mood = "Dark & Stormy"
		elsif rain.include? @weather_condition
			mood = "Rainy Day"
    elsif snow.include? @weather_condition
      mood = "Snowy Day"
    elsif fog.include? @weather_condition
      mood = "Foggy Day"
    elsif cold.include? @weather_condition
      mood = "Sweater Weather"
    elsif sunny.include? @weather_condition
      mood = "Sunny Day"
    elsif cloudy.include? @weather_condition
      mood = "For a cloudy day"
    elsif clear.include? @weather_condition
      mood = "Stargazing"
		else
			mood = "top hits"
		end

		s = Spotify.new(mood)
		s.recommend()
	end
end
