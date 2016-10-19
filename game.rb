class Player
	def initialize(email, position, moves)
		@eaten = []
		@is_alive = true
		@facing = "N"

		abort("No email provided")                      unless email.length > 0
		abort("No default position provided")           unless position.count == 2
		abort("No list of moves provided for " + email) unless moves.length > 0

		@email = email
		@position = position
		@moves = moves
	end

	attr_accessor :email
	attr_accessor :facing
	attr_accessor :position

	def is_alive?
		@is_alive
	end

	def move_for_turn(turn)
		@moves[turn]
	end

	def move_west!()
		@position = [@position[0] - 1, @position[1]]
	end

	def move_east!()
		@position = [@position[0] + 1, @position[1]]
	end

	def move_north!()
		@position = [@position[0], @position[1] - 1]
	end

	def move_south!()
		@position = [@position[0], @position[1] + 1]
	end

	def rotate_left!()
		@facing = case @facing
			when "N" then "W"
			when "W" then "S"
			when "S" then "E"
			when "E" then "N"
		end
	end

	def rotate_right!()
		@facing = case @facing
			when "N" then "E"
			when "E" then "S"
			when "S" then "W"
			when "W" then "N"
		end
	end

	def score()
		return @eaten.count
	end

	def eat!()
		@eaten = (@eaten + [@position]).uniq
	end

	def kill!()
		@is_alive = false
	end
end

class Game
	def initialize(entries)
		@players = []
		@gridsize = 7
		@holes = [ # [x, y]
			[4, 1],
			[1, 2],
			[6, 3],
			[2, 5],
			[5, 6]
		]
		@start = [3, 3]
		@turn = 0

		players_and_moves = entries.split("\n").map { |moveset| moveset.split(";") }
		@players = players_and_moves.map { |player_data| Player.new(player_data[0], @start, player_data[1]) }
	end

	attr_accessor :players
	attr_accessor :turn

	def count_move_in_turn(turn, movechar)
		@players.select { |player| player.is_alive? && player.move_for_turn(turn) == movechar }.count
	end

	def resolve_movement!()
		kill_players_off_board!()
		@players.select{:is_alive?}.each { |player| player.eat!() }
	end

	def move_board_up!()
		@players.select{:is_alive?}.each { |player| player.move_south!() }
	end

	def move_board_down!()
		@players.select{:is_alive?}.each { |player| player.move_north!() }
	end

	def move_board_west!()
		@players.select{:is_alive?}.each { |player| player.move_east!() }
	end

	def move_board_east!()
		@players.select{:is_alive?}.each { |player| player.move_west!() }
	end

	def kill_players_off_board!()
		@players.each do |player|
			if @holes.include? player.position or
				player.position[0] < 0 or
				player.position[1] < 0 or
				player.position[0] >= @gridsize or
				player.position[1] >= @gridsize

				player.kill!
			end
		end
	end

	def next_turn!()
		north_south = count_move_in_turn(@turn, "N") - count_move_in_turn(@turn, "S")
		west_east   = count_move_in_turn(@turn, "W") - count_move_in_turn(@turn, "E")

		# NS board movements first
		if (north_south > 0)
			north_south.times { move_board_up!() }
		elsif (north_south < 0)
			north_south.times { move_board_down!() }
		end

		# Then WE board movements
		if (west_east > 0)
			west_east.times { move_board_west!() }
		elsif (west_east < 0)
			west_east.times { move_board_east!() }
		end

		@players.select{:is_alive?}.each do |player|
			case player.move_for_turn(@turn)
			when "L" then player.rotate_left!
			when "R" then player.rotate_right!
			when "F"
				2.times do
					if player.is_alive?
						case player.facing
							when "N" then player.move_north!
							when "E" then player.move_east!
							when "S" then player.move_south!
							when "W" then player.move_west!
						end
						resolve_movement!
					end
				end
			end
		end

		@turn += 1
	end
end


#
# F Forward 2
# L Rotate left
# R Rotate right
# N Shift board north
# S Shift board south
# E Shift board east
# W Shift board west
input = <<-eos
lt696;NLRNSEWF
ab123;FESWNESF
ac987;LLLLLLLF
ad987;FLLLLLLF
af987;RFLLLLLF
ac98g;RFFLLLLF
eos

game = Game.new(input)
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
