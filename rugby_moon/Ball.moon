-- BALL --
-- a ball that can move on the field
class Ball extends Entity
	-- create a new ball at given location
	new: (world, mass, inertia, pos) =>
		super pos, DISPLAY.spritesBall, DISPLAY.ballSize, DISPLAY.ballSize, DISPLAY.ballBg, DISPLAY.ballShad
		@world, @mass, @inertia = world, mass, inertia
		@world\add @ -- add the object to the world
		@acc.y = @mass * PROPS.gravity
		@character = nil

	-- update the ball
	update:=>
		-- if the ball is held do not update
		if @character
			@pos\copy @character.pos
			return @

		-- make the ball bounce against the walls
		W, D = @world.width, @world.depth
		if     @pos.x < 0 then @pos.x, @vel.x = 0, -@vel.x
		elseif @pos.x > W then @pos.x, @vel.x = W, -@vel.x
		if     @pos.z < 0 then @pos.z, @vel.z = 0, -@vel.z
		elseif @pos.z > D then @pos.z, @vel.z = D, -@vel.z

		-- make the ball bounce on the ground
		ground = @world\ground @pos.x, @pos.z
		if @pos.y <= ground
			@pos.y = ground
			@vel.y = -@vel.y * @inertia
		super\update!

		return @
	
	-- if the ball is grabbed, do not render it
	render: (x, y) => if @character then @ else super\render x, y

-- END BALL --


