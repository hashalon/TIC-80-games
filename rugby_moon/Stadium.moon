-- STADIUM --
-- rectangular world with boundaries
class Stadium extends World
	-- create a new stadium with defined boundaries
	new: (n_players, width, depth) =>
		super n_players
		@width, @depth = width, depth
		@newBall! -- create a new ball
		-- define the camera
		@camera = 
			pos: @width / 2
			vel: 0
			acc: 0
		
		fullHeight = DISPLAY.bottomPad + DISPLAY.widthDepth + DISPLAY.topPad

		-- define the stripes of the field
		@stripe =
			number:     DISPLAY.n_stripes
			foreground: DISPLAY.stripeFore
			background: DISPLAY.stripeBack
			center:     SCREEN.width / 2
			horizon:    SCREEN.height - fullHeight
		
		@ratio =
			tilt:       DISPLAY.tilt
			fullHeight: fullHeight
			-- compute ratio to place the entities
			field:      DISPLAY.widthDepth / fullHeight
			fieldStart: DISPLAY.bottomPad  / fullHeight
			fieldEnd:   (DISPLAY.bottomPad + DISPLAY.widthDepth) / fullHeight
	
	update:=>
		super\update!
		-- smooth camera movements
		@camera.pos += @camera.vel
		@camera.vel += @camera.acc
		-- make the camera follow the ball
		if @ball
			if UTIL.sign2(@ball.vel.x, 10) == 0
				@camera.pos = @ball.pos.x
				@camera.vel = 0
				@camera.acc = 0
			else
				@camera.acc = (@ball.pos.x - @camera.pos) * 0.00001
		return

	-- create a new ball on the field
	newBall:=>
		ballPos = Vector @width/2, RUGBY.drop, @depth/2
		@ball = Ball @, 0.5, 0.8, ballPos
		return @ball

	-- convert coordinates from world to screen
	convert: (pos, width, y) =>
		y = y or pos.y -- we can redefine the y if we need to draw shadows
		-- we need to compute the perspective x position for top and bottom lines
		xs = @camera.pos - pos.x
		xb = @stripe.center - xs * @stripe.background
		xf = @stripe.center - xs * @stripe.foreground
		-- compute the position of the entity along the linear bezier curve
		t = @ratio.fieldStart + @ratio.field * pos.z / @depth
		fX = xb * t + xf * (1 - t) -- compute x
		fY = t * @ratio.fullHeight + y * @ratio.tilt
		-- compute scale of perceived object
		s = (@stripe.foreground / @stripe.background - 1) * (1 - t) + 1
		return fX, SCREEN.height - fY, s

	-- render the field using a simple perspective trick
	render:=>
		cls COLORS.sky
		rect 0, @stripe.horizon, SCREEN.width, SCREEN.height, COLORS.green1
		pad = -@camera.pos % 2

		-- draw multiple stripes
		for i = -@stripe.number, @stripe.number, 2
			width = pad + i
			xt = @stripe.center + width * @stripe.background
			xb = @stripe.center + width * @stripe.foreground
			UTIL.trap(
				xt, xt + @stripe.background, @stripe.horizon,
				xb, xb + @stripe.foreground, SCREEN.height  ,
				COLORS.green2)
		
		-- render the entities in the right order
		entities = @orderEntities!
		for e in *entities -- draw shadows
			x, y, s = @convert e.pos, e.w, DISPLAY.shadow
			e\castShadowS x, y, s
		for e in *entities -- draw entities
			x, y, s = @convert e.pos, e.w
			e\renderS x, y, s
		return

-- END STADIUM --


