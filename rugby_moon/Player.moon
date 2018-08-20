-- PLAYER --
-- player to manage input and attach to a character
class Player
	-- create either a player 1 or a player 2
	new: (n) => 
		@num = n
		@pad = switch @num
			when 0 then  0
			when 1 then  8
			when 2 then 16
			when 3 then 24

	-- return the inputs of the player
	input:=>
		x, z = 0, 0
		z += 1 if btn @pad     -- UP
		z -= 1 if btn @pad + 1 -- DOWN
		x -= 1 if btn @pad + 2 -- LEFT
		x += 1 if btn @pad + 3 -- RIGHT
		-- return DPAD, A, B
		return x, z, btn(@pad + 4), btn(@pad + 5), btn(@pad + 6), btn(@pad + 7)

-- END PLAYER --


