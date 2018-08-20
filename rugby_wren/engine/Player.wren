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

