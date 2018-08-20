/*
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

}