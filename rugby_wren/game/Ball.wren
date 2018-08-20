/*
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

}