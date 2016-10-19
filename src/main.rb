require_relative "Game.rb"
require_relative "Player.rb"

# F Forward 2
# L Rotate left
# R Rotate right
# N Shift board north
# S Shift board south
# E Shift board east
# W Shift board west

game = Game.new(STDIN.read)
results = {}
8.times do
	# Process next turn
	game.next_turn!()

	# Process into results list
	game.players.each do |player|
		if results[player.email]
			next if results[player.email].last == " "
			results[player.email] += [player.score]
		else
			results[player.email] = [player.score]
		end

		if !player.is_alive?
			results[player.email] += [" "]
		end
	end
end

max_length_email = results.keys.map {|email| email.length}.max
puts max_length_email
results.each do |email, scores|
	puts "#{email.ljust(max_length_email+1)} #{scores.map{|score| "#{score}".ljust(4)}.join("")}"
end
