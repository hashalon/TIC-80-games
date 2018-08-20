-- CHARACTER --
-- entity that is controlled by the player or an AI
class Character extends Entity
	-- create a character with a player assigned to it
	new: (world, pos, sprites, w, h, chroma, shadow) =>
		super pos, sprites, w, h, chroma, shadow
		@world, @player      = world, nil
		@speed, @jump, @mass = PROPS.speed, PROPS.jump, PROPS.mass
		@world\add @ -- add the object to the world
		@acc.y = @mass * PROPS.gravity

	-- update the character
	update:=>
		-- get the inputs from the player or the AI
		xAxis, zAxis, btnA, btnB, btnX, btnY = if @player 
			@player\input! else @behavior!

		-- apply movements
		ground = @world\ground @pos.x, @pos.z
		@vel.x, @vel.z = xAxis * @speed, zAxis * @speed
		@vel.y = @jump if btnA and @pos.y <= ground

		-- apply physics
		super\update!

		-- keep the character on the ground
		if @pos.y <= ground
			@pos.y = ground
			@vel.y = 0 if @vel.y < 0

		-- set the direction the character is facing
		if      xAxis != 0 then @flip =  xAxis > 0
		elseif @vel.x != 0 then @flip = @vel.x > 0

		return xAxis, zAxis, btnA, btnB, btnX, btnY

	-- AI of the character
	behavior:=>
		-- x, z, A, B, X, Y
		return 0, 0, false, false, false, false

-- END CHARACTER --


