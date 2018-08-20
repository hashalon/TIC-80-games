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

