-- title:  rugby game
-- author: Olivier Schyns
-- desc:   4 players rudby games
-- script: moon


-- util functions
UTIL =
	-- return the sign of the number
	sign:  (x)    -> x>0 and 1 or x<0  and -1 or 0
	sign2: (x, d) -> x>d and 1 or x<-d and -1 or 0

	-- perspective rectangle
	-- t1-t2
	-- | / |
	-- b1-b2
	trap: (xt1,xt2,yt, xb1,xb2,yb, col) ->
		tri xt1,yt, xt2,yt, xb1,yb, col
		tri xt2,yt, xb1,yb, xb2,yb, col
		return
	
	-- return squared distance between both positions
	sqrDist: (u, v) ->
		X, Y, Z = v.x - u.x, v.y - u.y, v.z - u.z
		return X*X + Y*Y + Z*Z
	
	-- return distance between both positions
	dist: (u, v) -> math.sqrt util.sqrDist(u,v)

	-- render textured rectangle to screen
	-- rectangle is defined as:
	-- (1) 1 --- 2
	--     |  \  |
	--     3 --- 4 (2)
	texrect: (x1, y1, x2, y2, x3, y3, x4, y4, u1, v1, u2, v2, use_map, chroma) ->
		use_map, chroma = use_map or false, chroma or -1
		textri(x1, y1, x2, y2, x4, y4, u1, v1, u2, v1, u2, v2, use_map, chroma)
		textri(x1, y1, x3, y3, x4, y4, u1, v1, u1, v2, u2, v2, use_map, chroma)
		return

	-- draw a sprite on the screen with the given scale
	-- x, y define the center of the sprite rather than the top left corner
	-- scale is a real number
	-- flip only horizontaly
	-- no rotation
	spr_x: (id, x, y, chroma, scale, flip, w, h) =>
		chroma = chroma or -1
		scale  = scale  or  1
		w, h = w or 1, h or 1

		-- compute offset of x's and y's
		-- (sprite unit = 8, so half is 4)
		w_2, h_2 = w * 4 * scale, h * 4 * scale
		x1, y1 = x - w_2, y - h_2
		x2, y2 = x + w_2, y + h_2

		-- compute uv position
		u1, v1 = (id % 16) * 8, (id // 16) * 8
		u2, v2 =    u1 + w * 8,     v1 + h * 8

		-- crop the sprite
		u1 += 0.5
		v1 += 0.5
		u2 -= 0.5
		v2 -= 0.5

		if flip -- flip sprite
			@.texrect(x1, y1, x2, y1, x1, y2, x2, y2, u2, v1, u1, v2, false, chroma)
		else -- do not flip sprite
			@.texrect(x1, y1, x2, y1, x1, y2, x2, y2, u1, v1, u2, v2, false, chroma)
		return

	-- draw a simple horizontal ellipse
	ellipse: (x, y, a, b, col) ->
		-- compute helper variables
		a_2, b_2 = a/2, b/2

		-- iterate over each pixel of the rectangle
		for i = -a_2, a_2 do for j = -b_2, b_2 do
			x_, y_ = i / a_2, j / b_2
			if x_*x_ + y_*y_ <= 1
				pix x+i, y+j, col

-- END UTIL --


-- CONFIG --
-- define the size of the screen
SCREEN =
	width:  240
	height: 136

-- define the properties of the entities of the game
PROPS =
	gravity: -0.3 -- gravity force
	speed:    0.1 -- speed of characters
	jump:     0.6 -- jump force of the characters
	ground:   0   -- ground level
	mass:     0.1 -- mass of the character

-- define the colors used
COLORS =
	sky:    13 -- color of the sky
	sun:    14 -- color of the sun
	green1:  5 -- first  color of the green
	green2: 11 -- second color of the green

-- additional properties
RUGBY =
	drop:        20 -- height where the ball is dropped
	speedFactor:  2 -- how faster should the ball move
	catchDist:   10 -- how far can we catch the ball

-- manage the display
DISPLAY = 
	-- how much margin are we putting when we display the field
	tilt:        5   -- how much will the height be visible
	shadow:     -1.7 -- how far down is the shadow of the entity
	widthDepth: 60   -- how many pixel the field will occupy on the screen
	topPad:     20   -- top margin
	bottomPad:  30   -- bottom margin
	-- stripes on the field
	n_stripes:   9 -- number of stripes to display on the field
	stripeBack: 16 -- width of the stripes in the background
	stripeFore: 32 -- width of the stripes in the foreground
	-- sprites of the characters
	spritesRed:  {16, 18} -- sprites used by team red
	spritesBlue: {48, 50} -- sprites used by team blue
	charWidth:    2  -- width  of the sprite
	charHeight:   2  -- height of the sprite
	charBg:      14  -- background of the sprite
	charShad:     3  -- the shadow of the character
	-- sprites of the ball
	spritesBall:  {1} -- sprites used by the ball
	ballSize:      1  -- size of the sprite of the ball
	ballBg:        0  -- background of the sprite
	ballShad:      2  -- the shadow of the ball

-- END CONFIG --


-- VECTOR --
-- vector 3D to do math
class Vector
	-- create a new vector
	new: (x, y, z) => @x, @y, @z = x, y, z

	-- make a copy of the vector
    clone:=> @@ @x,@y,@z
	copy: (v) =>
		@x, @y, @z = v.x, v.y, v.z
		return @

	-- apply to vector
	scale: (s) =>
		@x *= s
		@y *= s
		@z *= s
		return @

	-- faster to compute
    sqrMag:=> @x * @x + @y * @y + @z * @z

    -- magnitude of the vector
    magnitude:=> math.sqrt @sqrMag!

    -- normalize the vector s.t. its length is 1
    normalize:=>
        s = @sqrMag!
        if s == 1 then return @
        m = math.sqrt s
        @x /= m
        @y /= m
        @z /= m
        @

    __tostring:=> "Vector(#{@x}, #{@y}, #{@z})"
	
	-- basic vector operations
	__add: (v) => @@ @x + v.x, @y + v.y, @z + v.z
	__sub: (v) => @@ @x - v.x, @y - v.y, @z - v.z
	__mul: (c) => @@ @x * c  , @y * c  , @z * c

	__unm:=> @@ -@x, -@y, -@z
    __len:=> math.sqrt @sqrMag!

    __eq:(v)=> @x == v.x and @y == v.y and @z == v.z

    __index:(i)=> switch i
        when 1 then return @x
        when 2 then return @y
        when 3 then return @z
	
	-- vector operations
	@dot:   (u, v) -> u.x * v.x + u.y * v.y + u.z * v.z
	@cross: (u, v) -> @@(
		u.y * v.z - u.z * v.y,
		u.z * v.x - u.x * v.z,
		u.x * v.y - u.y * v.x)

	-- return a new null vector
	@zero:-> @@(0, 0, 0)

-- END VECTOR --


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


-- WORLD --
-- contains characters and objects
class World
	-- create a world with a list of entities
	new: (n_players) =>
		@entities, @ordered = {}, {} -- entities in the world
		@players = {} -- players that can interact with the world
		for i = 1, n_players
			@players[i] = Player i-1

	-- update our entities
	update:=>
		for e, _ in pairs @entities
			e\update!
		return

	-- manage entities
	add: (e) => 
		@entities[e] = true
		table.insert @ordered, e
	remove: (e) => 
		-- check that the entity is actually in the list
		if @entities[e]
			-- iterate the ordered list and remove the element
			for i, f in pairs @ordered
				if f == e then table.remove @ordered, i
			@entities[e] = nil
		return

	-- return the height of the ground
	ground: (x,z) => PROPS.ground

	-- render the world using the camera
	orderEntities:=>
		-- sort the list of object from farest to closest
		table.sort(@ordered, (a, b) -> a.pos.z > b.pos.z)
		return @ordered

-- END WORLD --


-- ENTITY --
-- entity with position, velocity and sprites
class Entity
	-- create a new entity with list of sprites
	new: (pos, sprites, w, h, chroma, shadow) =>
		-- physics
		@pos = Vector.clone pos
		@vel = Vector.zero!
		@acc = Vector.zero!
		-- rendering
		@sprites, @sprite_index, @flip = sprites, 1, false
		@w = w or 1 
		@h = h or @w
		@chroma, @shadow = chroma or -1, shadow

	-- apply velocity and acceleration to entity
	update:=>
		@pos\add @vel
		@vel\add @acc
		return @
	
	-- display a shadow at the given position
	castShadow: (x, y) =>
		if @shadow
			x -= @w * 4
			y -= 4
			spr @shadow, x, y, 15, 1, 0, 0, @w, 1
		return @

	castShadowS: (x, y, s) =>
		UTIL.ellipse x, y, @w*8*s, @h*3*s, 0
		return @

	-- basic print of the sprite without scaling
	render: (x, y) =>
		x -= @w * 4
		y -= @h * 4
		-- we may need to flip the sprite
		id = @sprites[@sprite_index]
		flip = if @flip then 1 else 0
		spr id, x, y, @chroma, 1, flip, 0, @w, @h
		return @
	
	-- print the sprite with scaling
	-- (the sprite may not be clean)
	renderS: (x, y, s) =>
		id = @sprites[@sprite_index]
		flip = if @flip then 1 else 0
		UTIL\spr_x id, x, y, @chroma, s, flip, @w, @h
		return @

-- END ENTITY --


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


-- create a stadium
stadium = Stadium 1, 100, 8

pos = Vector 50, 0, 4
man1 = RugbyMan stadium, false, pos
man1.player = stadium.players[1]

-- generate characters for each team
for i = 1,4
	pos = Vector 48, 0, i*2
	man = RugbyMan stadium, false, pos
for i = 1,4
	pos = Vector 52, 0, i*2
	man = RugbyMan stadium,  true, pos

-- update the stadium and render
export TIC=->
	stadium\update!
	stadium\render!
	print stadium.ball.pos.x

-- <TILES>
-- 001:00ffff000ffffff0ffffffffffffffffdffffffdddffffdd0dddddd000dddd00
-- 002:fffffffffffffffff000000f0000000000000000f000000fffffffffffffffff
-- 003:fffffffffffff000fff00000ff000000ff000000fff00000fffff000ffffffff
-- 004:ffffffff000fffff00000fff000000ff000000ff00000fff000fffffffffffff
-- 016:efffffffff222222f8888888f8222222f8fffffff8ff0ffff8ff0ffff8ff0fff
-- 017:fffffeee2222ffee88880fee22280feefff80fff0ff80f0f0ff80f0f0ff80f0f
-- 018:efffffffff222222f8888888f8222222f8fffffff8fffffff8ff0ffff8ff0fff
-- 019:fffffeee2222ffee88880fee22280feefff80ffffff80f0f0ff80f0f0ff80f0f
-- 032:f8fffffff8888888f888f888f8888ffff8888888f2222222ff000fffefffffef
-- 033:fff800ff88880ffef8880fee88880fee88880fee2222ffee000ffeeeffffeeee
-- 034:f8fffffff8888888f888f888f8888ffff8888888f2222222ff000fffefffffef
-- 035:fff800ff88880ffef8880fee88880fee88880fee2222ffee000ffeeeffffeeee
-- 048:efffffffff111111f6666666f6111111f6fffffff6ff0ffff6ff0ffff6ff0fff
-- 049:fffffeee1111ffee66660fee11160feefff60fff0ff60f0f0ff60f0f0ff60f0f
-- 050:efffffffff111111f6666666f6111111f6fffffff6fffffff6ff0ffff6ff0fff
-- 051:fffffeee1111ffee66660fee11160feefff60ffffff60f0f0ff60f0f0ff60f0f
-- 064:f6fffffff6666666f666f666f6666ffff6666666f1111111ff000fffefffffef
-- 065:fff600ff66660ffef6660fee66660fee66660fee1111ffee000ffeeeffffeeee
-- 066:f6fffffff6666666f666f666f6666ffff6666666f1111111ff000fffefffffef
-- 067:fff600ff66660ffef6660fee66660fee66660fee1111ffee000ffeeeffffeeee
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <PALETTE>
-- 000:140c1c44243430346d4e4a4e854c30346524d04648757161597dced27d2c8595a16daa2cd2aa996dc2cadad45edeeed6
-- </PALETTE>