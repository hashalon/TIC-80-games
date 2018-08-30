// title:  3D cube
// author: coding train
// desc:   3D projection of cube
// script: wren
// video:  https://youtu.be/p4Iz0XJY-Qk


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
	4×4 matrix
*/
class Matrix {

	construct identity () {
		_values = [
			1,0,0,0,
			0,1,0,0,
			0,0,1,0,
			0,0,0,1]
	}

	construct rotationX (rad) {
		_values = [
			
			]
	}

}

/*
	Cube in 3D space
*/
class Cube {
	
	construct default () {
		_points = [
			Vector.new(-1,-1,-1),
			Vector.new( 1,-1,-1),
			Vector.new( 1, 1,-1),
			Vector.new(-1, 1,-1),
			Vector.new(-1, 1, 1),
			Vector.new( 1, 1, 1),
			Vector.new( 1,-1, 1),
			Vector.new(-1,-1, 1)]

		_colors = [15,14,13, 12,11,10]
	}


}

class Game is TIC{

	construct new () {
		_t=0
		_x=0
		_y=0

		_s = 0.1
	}
	
	TIC(){
		if(TIC.btn(0)) _y = _y - _s
		if(TIC.btn(1)) _y = _y + _s
		if(TIC.btn(2)) _x = _x - _s
		if(TIC.btn(3)) _x = _x + _s
		
		_t = _t + 1
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
// </PALETTE>

