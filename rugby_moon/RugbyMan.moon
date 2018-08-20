-- RUGBYMAN --
class RugbyMan extends Character
	-- create a new rugby man character
	new: (world, team, pos) =>
		-- sprites to display the character
		sprites = if team then DISPLAY.spritesBlue else DISPLAY.spritesRed
		super world, pos, sprites, DISPLAY.charWidth, DISPLAY.charHeight, DISPLAY.charBg, DISPLAY.charShad
		-- state of the character
		@btnBPressed = false

	-- keep the character in the stadium
	update:=>
		-- get the inputs from the generic character update
		xAxis, zAxis, btnA, btnB, btnX, btnY = super\update!

		-- keep the sport man in the stadium
		W, D = @world.width, @world.depth
		if     @pos.x < 0 then @pos.x = 0
		elseif @pos.x > W then @pos.x = W
		if     @pos.z < 0 then @pos.z = 0
		elseif @pos.z > D then @pos.z = D

		-- if we press on the second button grab or throw
		if btnB and not @btnBPressed
			if @world.ball.character == @ -- throw the ball
				@world.ball.vel.x = @vel.x * RUGBY.speedFactor
				@world.ball.vel.z = @vel.z * RUGBY.speedFactor
				@world.ball.vel.y = if btnA then @jump else 0.1
				@world.ball.character = nil

			-- catch the ball
			elseif UTIL.sqrDist(@pos, @world.ball.pos) < 10
				@world.ball.character = @
			@btnBPressed = true
		if not btnB then @btnBPressed = false

		return xAxis, zAxis, btnA, btnB, btnX, btnY

-- END RUGBYMAN --


