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
