-- title:  rudby game
-- author: Olivier Schyns
-- desc:   2 players rudby game
-- script: moonscript

-- HELPERs --
util =
	-- return the sign of the number
	sign:  (x)   -> x>0 and 1 or x<0 and -1 or 0
	sign2: (x,d) -> x>d and 1 or x<0 and -d or 0

	-- return the uv coordinate for the selected sprite
	uv: (s, w, h) ->
		w = w or 1
		h = h or w
		u1, v1 = (s %  16) * 8, (s // 16) * 8
		u2, v2 = w * 8 + u1, h * 8 + v1
		return u1, v1, u2, v2
	
	-- print a textured rectangle to the screen
	-- rectangle is defined as:
	-- (1) 1 --- 2
	--     |  \  |
	--     3 --- 4 (2)
	texrect: (x1, y1, x2, y2, x3, y3, x4, y4, u1, v1, u2, v2, use_map, chroma) ->
		use_map, chroma = use_map or false, chroma or -1
		textri(
			x1, y1, x2, y2, x4, y4, 
			u1, v1, u2, v1, u2, v2, 
			use_map, chroma)
		textri(
			x1, y1, x3, y3, x4, y4,
			u1, v1, u1, v2, u2, v2,
			use_map, chroma)
		return
	
	-- return squared distance between both positions
	sqrDist: (u, v) ->
		X, Y, Z = v.x - u.x, v.y - u.y, v.z - u.z
		return X*X + Y*Y + Z*Z
	
	-- return distance between both positions
	dist: (u, v) -> math.sqrt util.sqrDist(u, v)


-- VECTOR --
-- vector 3D to do math
class Vector
	-- create a new vector
	new: (x,y,z) => @x, @y, @z = x, y, z

	-- apply to vector
	add: (v) =>
		@x += v.x
		@y += v.y
		@z += v.z
		return @
	sub: (v) =>
		@x -= v.x
		@y -= v.y
		@z -= v.z
		return @
	scale: (s) =>
		@x *= s
		@y *= s
		@z *= s
		return @

	-- basic vector operations
	__add: (v) => Vector @x + v.x, @y + v.y, @z + v.z
	__sub: (v) => Vector @x - v.x, @y - v.y, @z - v.z
	__mul: (c) => Vector @x * c  , @y * c  , @z * c
	
	-- vector operations
	dot:   (u, v) -> u.x * v.x + u.y * v.y + u.z * v.z
	cross: (u, v) -> Vector(
		u.y * v.z - u.z * v.y,
		u.z * v.x - u.x * v.z,
		u.x * v.y - u.y * v.x)
	
	-- return a copy of the vector
	copy: (v) -> Vector v.x, v.y, v.z

	-- return a new null vector
	zero:-> Vector(0, 0, 0)

-- CAMERA --
-- allow to see the world
class Camera
	-- create a new camera with position, rotation and field of view
	new: (pos, rot, fov) => @pos, @rot, @fov = pos, rot, fov

	-- render the world
	render: (world) =>
		entities = {}
		-- project all entities to camera space
		for e, _ in pairs world.entities
			e.proj = @project e.pos
			table.insert entities, e
		-- sort the list of object from farest to closest
		table.sort(entities, (a, b) -> a.proj.z < b.proj.z)
		-- render each object in order
		for e in *entities
			e\render!
		return
	
	-- project from world space to camera space
	-- https://en.wikipedia.org/wiki/3D_projection
	project: (worldpos) =>
		v = worldpos - @pos
		-- precompute sine and cosine
		sx, sy, sz = math.sin(@rot.x), math.sin(@rot.y), math.sin(@rot.z)
		cx, cy, cz = math.cos(@rot.x), math.cos(@rot.y), math.cos(@rot.z)
		-- precompute parts of formulas
		q0 = sz * v.y + cz * v.x
		q1 = cy * v.z + sy * q0
		q2 = cz * v.y - sz * v.x
		-- project the vector to camera space
		return Vector(
			cy * q0 - sy * v.z,
			sx * q1 + cx * q2,
			cx * q1 - sx * q2)

-- PLAYER --
-- player to manage input and attach to a character
class Player
	-- create either a player 1 or a player 2
	new: (isP1) => @isP1 = isP1

	-- return the inputs of the player
	input:=>
		side = if @isP1 then 0 else 8
		x, z = 0, 0
		z += 1 if btn side     -- UP
		z -= 1 if btn side + 1 -- DOWN
		x -= 1 if btn side + 2 -- LEFT
		x += 1 if btn side + 3 -- RIGHT
		-- return DPAD, A, B
		return x, z, btn(side + 4), btn(side + 5)

-- ENTITY --
-- entity with position, velocity and sprites
class Entity
	-- create a new entity with list of sprites
	new: (pos, sprites, w, h, chroma) =>
		-- physics
		@pos = Vector.copy(pos)
		@vel = Vector.zero!
		@acc = Vector.zero!
		-- rendering
		@w = w or 1 
		@h = h or w
		@chroma = chroma or -1
		@sprites, @spr_i = {}, 1
		for s in *sprites
			u1, v1, u2, v2 = util.uv(s, @w, @h)
			table.insert @sprites, {u1, v1, u2, v2}
		@proj = Vector.zero!

	-- apply velocity and acceleration to entity
	update:=>
		@pos\add @vel
		@vel\add @acc
		return @
	
	-- print the entity (as a billboard) to the screen
	render:=>
		w, h = @w * 0.5 / @proj.z, @h * 0.5 / @proj.z
		x1, y1 = @pos.x - w, @pos.y - h
		x2, y2 = @pos.x + w, @pos.y + h
		uv = @sprites[@spr_i]
		util.texrect(
			x1,y1, x2,y1, x1,y2, x2,y2,
			uv.u1, uv.v1, uv.u2, uv.v2,
			false, chroma)
		return

-- WORLD --
-- contains characters and objects
class World
	-- create a world with a list of entities
	new:=> 
		@entities = {}
		@p1 = Player true
		@p2 = Player false

	-- update our entities
	update:=>
		for e, _ in pairs @entities
			e\update!
		return

	-- manage entities
	add:    (e) => @entities[e] = true
	remove: (e) => @entities[e] = nil

---- END OF GENERIC CLASSES ----

-- define the properties of the entities of the game
props =
	gravity: -10 -- gravity force
	speed:    10 -- speed of characters
	jump:     30 -- jump force of the characters
	ground:    0 -- ground level

-- STADIUM --
-- rectangular world with boundaries
class Stadium extends World
	-- create a new stadium with defined boundaries
	new: (X, Z) =>
		super!
		@X, @Z = X, Z
		-- we need a camera to see the stadium
		@camera = Camera Vector(X/2, 30, -10), 0, 90 

	-- update the world
	update:=>
		super\update!
		-- keep the entities within the stadium
		for e, _ in pairs @entities
			if     e.x < 0  then e.x = 0
			elseif e.x > @X then e.x = @X
			if     e.z < 0  then e.z = 0
			elseif e.z > @Z then e.z = @Z
		return

-- CHARACTER --
-- entity that is controlled by the player or an AI
class Character extends Entity
	-- create a character with a player assigned to it
	new: (world, pos, sprites, w, h, chroma, player) =>
		super pos, sprites, w, h, chroma
		@world  = world
		@player = player
		@acc.y = props.gravity

	-- update the character
	update:=>
		-- get the inputs from the player or the AI
		xAxis, zAxis, btnA, btnB = if @player then @player\input! else @behavior!

		-- apply movements
		@vel.x, @vel.z = xAxis * props.speed, zAxis * props.speed
		@vel.y = props.jump if btnA and @pos.y <= props.ground
		-- TODO: apply charge with btnB

		-- apply physics
		super\update!

		-- keep the character on the ground
		if @pos.y <= props.ground
			@pos.y = props.ground
			@vel.y = 0 if @vel.y < 0

	-- AI of the character
	behavior:=>
		-- x, z, A, B
		return 0, 0, false, false

-- MAIN --
export TIC=->
	cls!
	print "WIP"


-- <PALETTE>
-- 000:140c1c44243430346d4e4a4e854c30346524d04648757161597dced27d2c8595a16daa2cd2aa996dc2cadad45edeeed6
-- </PALETTE>

-- <TILES>
-- 001:efffffffff222222f8888888f8222222f8fffffff8ff0ffff8ff0ffff8ff0fff
-- 002:fffffeee2222ffee88880fee22280feefff80fff0ff80f0f0ff80f0f0ff80f0f
-- 003:efffffffff222222f8888888f8222222f8fffffff8fffffff8ff0ffff8ff0fff
-- 004:fffffeee2222ffee88880fee22280feefff80ffffff80f0f0ff80f0f0ff80f0f
-- 017:f8fffffff8888888f888f888f8888ffff8888888f2222222ff000fffefffffef
-- 018:fff800ff88880ffef8880fee88880fee88880fee2222ffee000ffeeeffffeeee
-- 019:f8fffffff8888888f888f888f8888ffff8888888f2222222ff000fffefffffef
-- 020:fff800ff88880ffef8880fee88880fee88880fee2222ffee000ffeeeffffeeee
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

