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

