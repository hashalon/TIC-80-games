/*
	Ball object
*/
class Ball is Entity {
	
	drag {_drag}

	/* CONSTRUCTORs */
	construct new (position, mass, drag) {
		super(position, mass, __sprite, __shadow)
		_drag = drag
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

	// generate a sprite that can be used for all balls
	static Init () {
		__sprite = Sprite.new([1], 8, 8, 10, 0)
		__shadow = Shadow.new(12, 0)
	}

}