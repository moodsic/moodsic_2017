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
		@weather_condition = "amb"
		@change = "N"
	end

	private
	def weather_lookup(city, state)
		@weather = Weather.lookup_by_location("#{city}, #{state}", Weather::Units::FAHRENHEIT)
		@weather_condition = @weather.condition.text.to_s

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
		happy_weather_moods = ["Sunny"]
		sad_weather_moods = ["Cloudy", "Rain", "Showers"]
		if sad_weather_moods.any? { |cond| @weather_condition.include? cond}
			mood = "rainy"
		elsif happy_weather_moods.any? { |cond| @weather_condition.include? cond}
			mood = "happy"
		elsif @weather.condition.temp < 50
			mood = "sweater weather"
		elsif @weather.condition.temp > 90
			mood = "summer"
		else
			mood = "top hits"
		end
	
		s = Spotify.new(mood)
		s.recommend()
	end
end

