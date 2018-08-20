// title:  Rugby
// author: Olivier Schyns
// desc:   simple rugby game with perspective render
// script: wren


/*
	Contains helper function
*/
class Util {
	
	// return the sorted sequence
	static sortIncreasing (sequence) {
		// add elements in this array
		var array = []
		for (element in sequence) {

			// find where to place the element
			var j = 0
			for (i in 0...array.count) {

				// value in array just got greater !
				if (element < array[i]) {
					j = i
					break
				}
			}
			array.insert(j, element)
		}
		return array
	}
	static sortDecreasing (sequence) {
		// add elements in this array
		var array = []
		for (element in sequence) {

			// find where to place the element
			var j = 0
			for (i in 0...array.count) {

				// value in array just got smaller !
				if (element > array[i]) {
					j = i
					break
				}
			}
			array.insert(j, element)
		}
		return array
	}
}

/*
	contains functions to draw stuff
*/
class Draw {
	
	// size of the screen
	static width  {240}
	static height {136}
	static FPS    { 60}

	// draw a rectangle from spritesheet or map
	static texrect (
		x1, y1, x2, y2, x3, y3, x4, y4, 
		u1, v1, u2, v2, 
		use_map, chroma) {
		TIC.textri(
			x1, y1, x2, y2, x4, y4, 
			u1, v1, u2, v1, u2, v2, 
			use_map, chroma)
		TIC.textri(
			x1, y1, x3, y3, x4, y4,
			u1, v1, u1, v2, u2, v2,
			use_map, chroma)
	}
	static texrect (
		x1, y1, x2, y2,
		u1, v1, u2, v2, 
		use_map, chroma) {
		TIC.textri(
			x1, y1, x2, y1, x2, y2, 
			u1, v1, u2, v1, u2, v2, 
			use_map, chroma)
		TIC.textri(
			x1, y1, x1, y2, x2, y2,
			u1, v1, u1, v2, u2, v2,
			use_map, chroma)
	}

	// draw ellipse line by line
	static ellipse (x, y, a, b, color) {
		x = x.round
		y = y.round
		a = a.ceil
		b = b.ceil

		// prepare values
		var x1 = x - a
		var y1 = y - b
		var x2 = x + a
		var y2 = y + b

		var a2 = a * a
		var b2 = b * b

		y1 = y1.floor
		y2 = y2.ceil
		//TIC.trace("%(y1), %(y2)")

		for (i in y1..y2) {
			// solve ellipse-line intersection equation
			var dist = i - y
			var q = (((1 - dist * dist / b2) * a2).sqrt).ceil
			TIC.rect(x - q, i, q * 2, 1, color)
			//TIC.trace("%(x - q), %(y + i)")
		}
	}

	static trapezoid (x1,y1, x2,y2, x3,y3, x4,y4, color) {
		TIC.tri(x1,y1, x2,y2, x3,y3, color)
		TIC.tri(x1,y1, x3,y3, x4,y4, color)
	}
}

/*
	3D vector
*/
class Vector {
	
	/* GETTERs */
	x {_x}
	y {_y}
	z {_z}

	/* SETTERs */
	x=(a) {_x = a}
	y=(b) {_y = b}
	z=(c) {_z = c}

	sqrMagnitude {_x*_x + _y*_y + _z*_z}
	magnitude {sqrMagnitude.sqrt}

	/* CONSTRUCTORs */
	construct zero () {
		_x = 0
		_y = 0
		_z = 0
	}
	construct new (x,y,z) {
		_x = x
		_y = y
		_z = z
	}

	/* METHODs */
	normalize () {
		var mag = sqrMagnitude
		if (mag == 1) return this
		mag = mag.sqrt
		_x = _x / mag
		_y = _y / mag
		_z = _z / mag
		return this
	}

	clone () {Vector.new(_x, _y, _z)}
	copy (v) {
		_x = v.x
		_y = v.y
		_z = v.z
	}


	/* OPERATORs */
	+(v) {Vector.new( _x+v.x, _y+v.y, _z+v.z )}
	-(v) {Vector.new( _x-v.x, _y-v.y, _z-v.z )}
	*(s) {Vector.new( _x*s  , _y*s  , _z*s   )}
	/(s) {Vector.new( _x/s  , _y/s  , _z/s   )}

	- {Vector.new( -_x, -_y, -_z )}

	==(v) { _x == v.x && _y == v.y && _z == v.z }
	!=(v) { _x != v.x || _y != v.y || _z != v.z }

}

/*
	a world containing entities
*/
class World {
	
	/* GETTERs */
	static world {__world}

	camera   {_camera  }
	entities {_entities}

	[number] {_players[number]}

	/* SETTERs */


	/* CONSTRUCTORs */
	construct new (camera, nb_players) {
		__world   = this   // singleton
		_camera   = camera // render the world
		_entities = []     // list of entities
		_players  = []     // up to 4 players

		// setup players
		for (i in 0...nb_players) _players.add(Player.new(i))
	}

	/* METHODs */

	// update the world
	update () {
		// update each entity and each player input
		for (entity in _entities) entity.update()
		for (player in _players ) player.update()
	}

	// draw the world
	draw () {
		// build an array to define the draw order
		var ents = Util.sortDecreasing(_entities)

		// draw the shadows and then the sprites
		for (entity in ents) entity.drawShadow()
		for (entity in ents) entity.drawSprite()
	}

	
	// add and remove entities from the world
	add (entity) {_entities.add(entity)}

	remove (entity) {
		for (i in 0..._entities.count) {
			if (_entities[i] == entity) {
				_entities.removeAt(i)
				return this
			}
		}
	}

	clear () {_entities.clear()}

	// project position to the ground
	projectToGround (position) {
		// ground is at height 0
		var p = position.clone()
		p.y = 0
		return p
	}
}

/*
	game entity
*/
class Entity {
	
	/* GETTERs */
	position     {_position}
	velocity     {_velocity}
	acceleration {_acceleration}

	// allow access to child classes
	sprite {_sprite}
	shadow {_shadow}

	// order entities based on their z-position
	<(e) { _position.z < e.position.z }
	>(e) { _position.z > e.position.z }

	/* SETTERs */
	position=(p)     {_position.copy(p)}
	velocity=(v)     {_velocity.copy(v)}
	acceleration=(a) {_acceleration.copy(a)}

	/* CONSTRUCTORs */
	construct new (position, sprite, shadow) {

		_position     = position.clone()
		_velocity     = Vector.zero()
		_acceleration = Vector.zero()

		// draw the entity
		_sprite = sprite
		_shadow = shadow
	}

	/* METHODs */
	update () {
		_position = _position + _velocity     / Draw.FPS
		_velocity = _velocity + _acceleration / Draw.FPS
		return this
	}



	// given transformation, draw shadow
	drawShadow () {
		if (!World.world.camera.inField(_position.x)) return

		// transform
		var pro = World.world.projectToGround(_position)
		var trs = World.world.camera.transform(pro)

		// draw the shadow
		var t = (-World.world.camera.tilt).sin
		_shadow.draw(trs.x, trs.y, t, 1/trs.z)
	}	

	// given transformation, draw sprite
	drawSprite () {
		if (!World.world.camera.inField(_position.x)) return

		// transform
		var trs  = World.world.camera.transform(_position)
		var flip = false // to override
		var id   = 0     // to override

		// draw the sprite
		_sprite.draw(id, trs.x, trs.y, 1/trs.z, flip)
	}

}

/*
	List of sprites to render an entity
*/
class Sprite {
	
	/* GETTERs */
	[index] {_ids[index]}

	width  {_width }
	height {_height}
	scale  {_scale }

	/* CONSTRUCTORs */
	// provide a list of ids, the size of the sprites and the background color
	construct new (ids, width, height, scale, background) {
		// generate list of uv coordinates
		_ids = ids
		_coords_u = []
		_coords_v = []
		for (id in ids) {
			_coords_u.add((id % 16)       * 8)
			_coords_v.add((id / 16).floor * 8)
		}

		_width  = width
		_height = height
		_scale  = scale

		_background = background

	}

	/* METHODs */
	draw (id, x, y, scale, flip) {
		// prepare texture coordinates
		var u1 = _coords_u[id]
		var v1 = _coords_v[id]
		var u2 = u1 + _width
		var v2 = v1 + _height

		// prepare drawing coordinates
		var w = _width  * _scale * scale / 2
		var h = _height * _scale * scale / 2
		var x1 = x - w
		var y1 = y - h
		var x2 = x + w
		var y2 = y + h

		// flip the sprite
		if (flip) {
			var tmp = u1
			u1 = u2
			u2 = tmp
		}

		// draw the sprite
		Draw.texrect(x1, y1, x2, y2, u1, v1, u2, v2, false, _background)
	}
}

/*
	a shadow to render under the object
*/
class Shadow {
	
	radius {_radius}
	color  {_color}

	// define an ellipse shape and a color
	construct new (radius, color) {
		_radius = radius
		_color  = color
	}

	draw (x, y, tiltSin, scale) {
		var a = (_radius * scale).ceil
		var b = (_radius * scale * tiltSin).ceil
		//TIC.trace("%(x), %(y), %(a), %(b)")
		Draw.ellipse(x, y , a * 2, b * 2, _color)
		//TIC.rect(x - a, y - b, a * 2, b * 2, _color)
	}

}

/*
	Define the zone that is visible and apply transformations to objects
*/
class Camera {
	
	/* GETTERs */
	position   {_position  }
	tilt       {_tilt      }
	orthoScale {_orthoScale}
	nearPlane  {_nearPlane }
	mix        {_mix       }
	field      {_field     }

	/* SETTERs */
	position  =(p) {_position.copy(p)}
	nearPlane =(n) {_nearPlane = n}
	mix       =(m) {_mix       = m}

	orthoScale =(s) {
		_orthoScale = s
		_field = 1.5 * Draw.width / _orthoScale
	}

	tilt=(t) {
		_tilt = t
		_tiltSin = (-_tilt).sin
		_tiltCos = (-_tilt).cos
	}

	/* CONSTRUCTORs */
	// initial position of the camera, tilt in radian,
	// orthographic scale, near plane distance, 
	// mix between orthographic and perspective
	construct new (position, tilt, orthoScale, nearPlane, mix) {
		_position   = position.clone()
		_tilt       = tilt       // rotation
		_orthoScale = orthoScale // orthographic scale
		_nearPlane  = nearPlane  // frustrum near place
		_mix        = mix        // transform mix

		// precompute
		_tiltSin = (-_tilt).sin
		_tiltCos = (-_tilt).cos

		_field = 1.5 * Draw.width / _orthoScale
	}

	// transform a point to render it on the screen
	transform (point) {
		// rotate point in camera space
		var vec = point - _position
		var z = vec.z * _tiltCos - vec.y * _tiltSin
		var y = vec.z * _tiltSin + vec.y * _tiltCos
		//TIC.trace("%(z), %(y)")

		// get transformed point with an orthographic and a perspective camera
		var ortho = orthoTransform(vec.x, y, z)
		var persp = perspTransform(vec.x, y, z)

		// mix both results to build transformed point
		var out = (ortho * (1 - _mix)) + (persp * _mix)

		// place it in the screen
		out.x = (Draw.width  / 2) + out.x
		out.y = (Draw.height / 2) - out.y
		return out
	}

	// apply orthographic transformation to rotated vector
	orthoTransform (x, y, z) {
		return Vector.new(x * _orthoScale, y * _orthoScale, z)
	}

	// apply perspective transformation to rotated vector
	perspTransform (x, y, z) {
		// http://www.cse.psu.edu/~rtc12/CSE486/lecture12.pdf

		// if too close => bug
		if (z <= 0) return Vector.zero()

		// formula to get projected size
		var s = 100 * _nearPlane / z
		return Vector.new(x * s, y * s, z)
	}

	// given simply the x position, 
	// return true if the position could be seen by the camera
	inField (x) {-_field <= x && x <= _field}

	/* return the coords to draw the point on screen
	transform (point) {
		// vector from camera to point
		var vec = point - _position

		// if the point is behind the camera, give up
		if (vec.z <= 0) return null

		// the closer the camera is, the bigger the object will be
		var s = _scale + _fov / vec.z

		// find vertical position given the tilt
		// https://en.wikipedia.org/wiki/Vector_projection
		var y = vec.y * _tilt.sin + vec.z * _tilt.cos

		// build transformed point
		var w = Draw.width  / 2
		var h = Draw.height / 2
		return Vector.new(w + (vec.x * s), h - (y * s), scale * s)
	} */

}

/*
	Manage player controls
*/
class Player {
	
	/* GETTERs */
	x {_x}
	y {_y}
	jump   {_jump  }
	attack {_attack}
	number {_number}
	
	/* CONTRUCTORs */
	construct new (number) {
		_number  = number
		_padding = number * 8

		// actions of the player
		_x = 0
		_y = 0
		_jump   = false
		_attack = false
	}

	/* METHODs */
	update () {
		// handle directions
		_x = 0
		_y = 0
		if (TIC.btn(_padding + 0)) _y = _y + 1 // UP
		if (TIC.btn(_padding + 1)) _y = _y - 1 // DOWN
		if (TIC.btn(_padding + 2)) _x = _x - 1 // LEFT
		if (TIC.btn(_padding + 3)) _x = _x + 1 // RIGHT

		// handle actions
		_jump   = TIC.btnp(_padding + 4) || TIC.btnp(_padding + 6)
		_attack = TIC.btnp(_padding + 5) || TIC.btnp(_padding + 7)
	}

}

/*
	Stadium for our game
*/
class Stadium is World {
	
	static white  {15}
	static green1  {5}
	static green2 {11}

	/* GETTERs */
	width  {_width }
	depth  {_depth }
	stripe {_stripe}

	/* SETTERs */
	width  =(w) {_width  = w}
	depth  =(d) {_depth  = d}
	stripe =(s) {_stripe = s}

	construct new (camera, nb_players, width, depth, stripe) {
		super(camera, nb_players)

		_width  = width
		_depth  = depth
		_stripe = stripe
	}

	// draw the stadium then the objects in it
	draw () {
		// draw green strippes
		var cx = camera.position.x
		var cf = camera.field
		var d  = _depth / 2
		var nbSteps = (2 * camera.field / _stripe).ceil

		// prepare starting point
		var x = (cx - cf) - (cx % _stripe)
		var c = (x % (_stripe * 2)) == 0
		//TIC.trace(x)

		// prepare the two first points
		var p1 = camera.transform(Vector.new(x, 0, -d))
		var p2 = camera.transform(Vector.new(x, 0,  d))

		//TIC.trace(p1.x)
		for (str in 0...nbSteps) {
			// prepare two second points
			x = x + _stripe
			var p3 = camera.transform(Vector.new(x, 0, -d))
			var p4 = camera.transform(Vector.new(x, 0,  d))

			var color = c ? Stadium.green1 : Stadium.green2
			Draw.trapezoid(p1.x,p1.y, p2.x,p2.y, p4.x,p4.y, p3.x,p3.y, color)

			// shift points
			p1 = p3
			p2 = p4
			c = !c
		}

		// trace border lines
		var line1 = camera.transform(Vector.new(x, 0, -d))
		var line2 = camera.transform(Vector.new(x, 0,  d))
		TIC.rect(0, line1.y, Draw.width, 1, Stadium.white)
		TIC.rect(0, line2.y, Draw.width, 1, Stadium.white)

		super.draw()
	}

}/*
	Ball object
*/
class Ball is Entity {
	
	mass {_mass}
	drag {_drag}

	/* CONSTRUCTORs */
	construct new (position, mass, drag) {
		super(position, __sprite, __shadow)

		_mass = mass
		_drag = drag

		acceleration = Vector.new(0, -_mass, 0)
	}

	/* METHODs */
	update () {
		super.update()

		// make small bounces
		if (position.y <= 0) {
			position.y = 0
			velocity.y = -velocity.y * _drag
		}
	}

	impulse (force) { velocity.copy(force) }

	// generate a sprite that can be used for all balls
	static Init () {
		__sprite = Sprite.new([1], 8, 8, 10, 0)
		__shadow = Shadow.new(12, 0)
	}

}/*
	RugbyMan that can be controlled by a player or an AI
*/
class RugbyMan is Entity {
	
	/* GETTERs */
	team   {_team  }
	mass   {_mass  }
	speed  {_speed }
	jump   {_jump  }
	player {_player}

	/* SETTERs */
	player =(p) {_player = p}

	/* CONSTRUCTORs */
	construct new (position, team, mass, speed, jump) {
		var sprite = team ? __spriteA : __spriteB
		var shadow = team ? __shadowA : __shadowB
		super(position, sprite, shadow)

		_team   = team
		_mass   = mass
		_speed  = speed
		_jump   = jump
		_player = null

		acceleration = Vector.new(0, -_mass, 0)
	}

	/* METHODs */
	update () {
		super.update()

		var grounded = false
		if (position.y <= 0) {
			position.y = 0
			velocity.y = 0
			grounded = true
		}

		// controlled by a player
		if (_player != null) {
			velocity.x = _player.x * _speed
			velocity.z = _player.y * _speed

			if (_player.jump && grounded) {
				velocity.y = _jump
			}
		}
	}

	static Init () {
		__spriteA = Sprite.new([1], 16, 16, 10, 0)
		__shadowA = Shadow.new(20, 0)

		__spriteB = Sprite.new([1], 16, 16, 10, 0)
		__shadowB = Shadow.new(20, 0)
	}

}/*
	Entry point of the program
*/
class Game is TIC{

	construct new () {
		// initialize elements
		Ball.Init()
		RugbyMan.Init()


		
		//_camera = Camera.new(p, -Num.pi / 8, 8, 2, 0.65)
		//_camera = Camera.new(p, -Num.pi / 4, 8, 10, 0.5)

		_camera = Camera.new(Vector.new(0, 7, -4), -Num.pi / 4, 10, 1, 0.5)
		_stadium = Stadium.new(_camera, 1, 100, 5, 2)

		var ball = Ball.new(Vector.new(0, 3, 0), 1, 0.9)
		var man  = RugbyMan.new(Vector.new(3, 3, 0), false, 3, 3, 5)
		_stadium.add(ball)
		_stadium.add(man)

		man.player = _stadium[0]

		_t = 0



	}
	
	TIC () {
		TIC.cls(13)

		//_camera.tilt = _camera.tilt + 0.01
		//_camera.mix = Num.pi / 8 + _t.sin * 0.05
		//_stadium.depth = (_t.sin * 10).abs
		//TIC.print(_stadium.depth)
		//_camera.nearPlane = (_t.sin).abs
		_camera.position.x = _t.sin * 10
		_t = _t + 0.001

		/*
		for (i in 0...10) {
			var p1 = Vector.new(-10, 0, -5 + i)
			var p2 = Vector.new( 10, 0, -5 + i)

			var t1 = _camera.transform(p1)
			var t2 = _camera.transform(p2)

			TIC.trace("%(t1.x), %(t1.y), %(t1.z)")

			TIC.line(t1.x, t1.y, t2.x, t2.y, 15)
		}
		// */

		//var p = _camera.transform(Vector.zero())
		//TIC.trace("%(p.x), %(p.y), %(p.z)")


		//Draw.trapezoid(t1.x,t1.y, t2.x,t2.y, t3.x,t3.y, t4.x,t4.y, 15)

		_stadium.update()
		_stadium.draw()

		//Draw.ellipse(120, 50, 10, 5, 0)
	}
}


// <TILES>
// 001:efffffffff222222f8888888f8222222f8fffffff8ff0ffff8ff0ffff8ff0fff
// 002:fffffeee2222ffee88880fee22280feefff80fff0ff80f0f0ff80f0f0ff80f0f
// 003:efffffffff222222f8888888f8222222f8fffffff8fffffff8ff0ffff8ff0fff
// 004:fffffeee2222ffee88880fee22280feefff80ffffff80f0f0ff80f0f0ff80f0f
// 017:f8fffffff8888888f888f888f8888ffff8888888f2222222ff000fffefffffef
// 018:fff800ff88880ffef8880fee88880fee88880fee2222ffee000ffeeeffffeeee
// 019:f8fffffff8888888f888f888f8888ffff8888888f2222222ff000fffefffffef
// 020:fff800ff88880ffef8880fee88880fee88880fee2222ffee000ffeeeffffeeee
// </TILES>

// <WAVES>
// 000:00000000ffffffff00000000ffffffff
// 001:0123456789abcdeffedcba9876543210
// 002:0123456789abcdef0123456789abcdef
// </WAVES>

// <SFX>
// 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
// </SFX>

// <PALETTE>
// 000:140c1c44243430346d4e4a4e854c30346524d04648757161597dced27d2c8595a16daa2cd2aa996dc2cadad45edeeed6
// </PALETTE>