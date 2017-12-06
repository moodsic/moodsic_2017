module LocationHelper
  require 'rspotify'
  require 'weather-api'

  private
	def s_initialize()
		spotify_client_id = "04a41877bac9440fbc50bc3092fbabcd"
		spotify_client_secret = "77e72f750de845509ba7dccb34102956"
		RSpotify.authenticate(spotify_client_id, spotify_client_secret)
	end

	private
	def recommend(mood)
    s_initialize()
    @mood = mood
    case mood
      when "Dark & Stormy"
        @color = "#2e323c"
      when "Rainy Day"
        @color = "#6a7d8e"
      when "Foggy Day", "For a cloudy day", "Snowy Day"
        @color = "#aebbc7"
      when "Sweater Weather"
        @color = "#6a7d8e"
      when "Sunny Day"
        @color = "#f9d3a5"
      when "Stargazing"
        @color = "#355c7d"
      else
        @color = "#495f77"
    end
		recommended_playlist = RSpotify::Playlist.search(@mood)
    @playlist_name = recommended_playlist.first.name
		@recommended_songs = recommended_playlist.first.tracks
    return [@color, @playlist_name, @recommended_songs]

	end

	public
	def weather_lookup(loc)
		@weather_loc = Weather.lookup_by_location("#{loc.content}", Weather::Units::FAHRENHEIT)
		@weather_condition = @weather_loc.condition.code.to_i
    set_mood(@weather_condition)
	end

	private
	def set_mood(weather_condition)
    @weather_condition = weather_condition
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
		return recommend(mood)
	end
end
