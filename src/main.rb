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

	game.players.each do |player|
		if results[player.email]
			if results[player.email].last == "Dead"
				next
			end
			results[player.email] += [player.score]
		else
			results[player.email] = [player.score]
		end

		if !player.is_alive?
			results[player.email] += ["Dead"]
		end
	end
end

results.each do |email, scores|
	puts "#{email}: #{scores.join(', ')}"
end
