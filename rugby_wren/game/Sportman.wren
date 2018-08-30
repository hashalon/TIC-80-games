/*
	Sportman that can be controlled by a player or an AI
*/
class Sportman is Entity {
	
	/* GETTERs */
	team   {_team  }
	speed  {_speed }
	jump   {_jump  }
	player {_player}

	/* SETTERs */
	player =(p) {_player = p}

	/* CONSTRUCTORs */
	construct new (position, mass, size, team, speed, jump) {
		var sprite = team ? __spriteA : __spriteB
		var shadow = team ? __shadowA : __shadowB
		super(position, mass, size, sprite, shadow)

		_team   = team
		_speed  = speed
		_jump   = jump
		_player = null
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