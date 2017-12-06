require_relative "mood"

puts "What would you like Moodsic to recommend songs, by weather or by twitter (W/T)? "
decide = gets.chomp.upcase

case decide
	when "W"
		w = WeatherMood.new()
		w.check_input()
	# when "T"
	# 	twitter_mood()
	else
		puts "Error: must select W or T."
end