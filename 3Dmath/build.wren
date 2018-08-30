// title:  3D cube
// author: coding train
// desc:   3D projection of cube
// script: wren
// video:  https://youtu.be/p4Iz0XJY-Qk


/*
	Draw functions
*/

class Draw {
	
	static width  {240}
	static height {136}

	static quad (x1,y1, x2,y2, x3,y3, x4,y4, color) {
		TIC.tri(x1,y1, x2,y2, x3,y3, color)
		TIC.tri(x1,y1, x4,y4, x3,y3, color)
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
	4×4 matrix
*/
class Matrix {

	/* GETTERs */
	values  {_values}
	[index] {_values[index]}

	/* CONSTRUCTORS */

	construct identity () {
		_values = [
			1,0,0,0,
			0,1,0,0,
			0,0,1,0,
			0,0,0,1]
	}

	construct build (values) {
		_values = values
	}

	/* Translation matrix */

	construct translation (x,y,z) {
		_values = [
			1,0,0,x,
			0,1,0,y,
			0,0,1,z,
			0,0,0,1]
	}

	/* Scaling */

	construct scale (x,y,z) {
		_values = [
			x,0,0,0,
			0,y,0,0,
			0,0,z,0,
			0,0,0,1]
	}

	/* Rotation matrices */

	construct rotationX (rad) {
		var s = rad.sin
		var c = rad.cos
		_values = [
			 1, 0, 0, 0,
			 0, c,-s, 0,
			 0, s, c, 0,
			 0, 0, 0, 1]
	}
	construct rotationY (rad) {
		var s = rad.sin
		var c = rad.cos
		_values = [
			 c, 0, s, 0,
			 0, 1, 0, 0,
			-s, 0, c, 0,
			 0, 0, 0, 1]
	}
	construct rotationZ (rad) {
		var s = rad.sin
		var c = rad.cos
		_values = [
			 c,-s, 0, 0,
			 s, c, 0, 0,
			 0, 0, 1, 0,
			 0, 0, 0, 1]
	}

	/* Projection matrices */

	construct projection (fov, near, far) {
		// http://www.codinglabs.net/article_world_view_projection_matrix.aspx
		// aspect ratio : width/height
		var a = Draw.height/Draw.width // inverse of aspect ratio
		var t = 1/(fov/2).tan
		var d = -1/(far - near)
		var s = far + near
		var p = 2*far*near

		_values = [
			a*t, 0,   0,   0,
			  0, t,   0,   0,
			  0, 0, s*d, p*d,
			  0, 0,  -1,   0]
	}

	/* OPERATORS */

	*(o) {
		if (o is Vector) return multVector(o) 
		return multMatrix(o)
	}


	/* METHODS */

	clone () {
		var values = []
		for (v in _values) {
			values.add(v)
		}
		return Matrix.build(values)
	}
	copy (m) {
		for (i in 0...m.values.count) {
			_values[i] = m.values[i]
		}
		return this
	}

	multVector (vector) {

		// prepare self
		var s0 = _values[0x0]
		var s1 = _values[0x1]
		var s2 = _values[0x2]
		var s3 = _values[0x3]

		var s4 = _values[0x4]
		var s5 = _values[0x5]
		var s6 = _values[0x6]
		var s7 = _values[0x7]

		var s8 = _values[0x8]
		var s9 = _values[0x9]
		var sA = _values[0xA]
		var sB = _values[0xB]

		var sC = _values[0xC]
		var sD = _values[0xD]
		var sE = _values[0xE]
		var sF = _values[0xF]

		// prepare other
		var x = vector.x
		var y = vector.y
		var z = vector.z
		var w = 1

		var X = s0*x + s1*y + s2*z + s3*w
		var Y = s4*x + s5*y + s6*z + s7*w
		var Z = s8*x + s9*y + sA*z + sB*w
		var W = sC*x + sD*y + sE*z + sF*w

		return Vector.new(X/W, Y/W, Z/W)
	}

	multMatrix (matrix) {

		// prepare self
		var s0 = _values[0x0]
		var s1 = _values[0x1]
		var s2 = _values[0x2]
		var s3 = _values[0x3]

		var s4 = _values[0x4]
		var s5 = _values[0x5]
		var s6 = _values[0x6]
		var s7 = _values[0x7]

		var s8 = _values[0x8]
		var s9 = _values[0x9]
		var sA = _values[0xA]
		var sB = _values[0xB]

		var sC = _values[0xC]
		var sD = _values[0xD]
		var sE = _values[0xE]
		var sF = _values[0xF]

		// prepare other
		var o0 = matrix[0x0]
		var o1 = matrix[0x1]
		var o2 = matrix[0x2]
		var o3 = matrix[0x3]

		var o4 = matrix[0x4]
		var o5 = matrix[0x5]
		var o6 = matrix[0x6]
		var o7 = matrix[0x7]

		var o8 = matrix[0x8]
		var o9 = matrix[0x9]
		var oA = matrix[0xA]
		var oB = matrix[0xB]

		var oC = matrix[0xC]
		var oD = matrix[0xD]
		var oE = matrix[0xE]
		var oF = matrix[0xF]

		var values = [
			// row 0
			s0*o0 + s1*o4 + s2*o8 + s3*oC,
			s0*o1 + s1*o5 + s2*o9 + s3*oD,
			s0*o2 + s1*o6 + s2*oA + s3*oE,
			s0*o3 + s1*o7 + s2*oB + s3*oF,
			// row 1
			s4*o0 + s5*o4 + s6*o8 + s7*oC,
			s4*o1 + s5*o5 + s6*o9 + s7*oD,
			s4*o2 + s5*o6 + s6*oA + s7*oE,
			s4*o3 + s5*o7 + s6*oB + s7*oF,
			// row 2
			s8*o0 + s9*o4 + sA*o8 + sB*oC,
			s8*o1 + s9*o5 + sA*o9 + sB*oD,
			s8*o2 + s9*o6 + sA*oA + sB*oE,
			s8*o3 + s9*o7 + sA*oB + sB*oF,
			// row 3
			sC*o0 + sD*o4 + sE*o8 + sF*oC,
			sC*o1 + sD*o5 + sE*o9 + sF*oD,
			sC*o2 + sD*o6 + sE*oA + sF*oE,
			sC*o3 + sD*o7 + sE*oB + sF*oF]
		return Matrix.build(values)
	}

}


/*
	define a Box mesh
*/
class Box {

	/* CONSTRUCTORs */
	construct new (width,height,depth, colors) {

		var w = width  / 2
		var h = height / 2
		var d = depth  / 2

		_points = [
			Vector.new(-w,-h,-d),
			Vector.new( w,-h,-d),
			Vector.new( w, h,-d),
			Vector.new(-w, h,-d),
			Vector.new(-w, h, d),
			Vector.new( w, h, d),
			Vector.new( w,-h, d),
			Vector.new(-w,-h, d)]

		_colors = colors
	}

	construct default () {
		var s = 0.5

		_points = [
			Vector.new(-s,-s,-s),
			Vector.new( s,-s,-s),
			Vector.new( s, s,-s),
			Vector.new(-s, s,-s),
			Vector.new(-s, s, s),
			Vector.new( s, s, s),
			Vector.new( s,-s, s),
			Vector.new(-s,-s, s)]

		_colors = [15,14,13, 12,11,10]
	}

	/* METHODs */

	// use provided transformation matrix to render the cube
	render (matrix) {

		// prepare the points
		var p0 = matrix * _points[0]
		var p1 = matrix * _points[1]
		var p2 = matrix * _points[2]
		var p3 = matrix * _points[3]

		var p4 = matrix * _points[4]
		var p5 = matrix * _points[5]
		var p6 = matrix * _points[6]
		var p7 = matrix * _points[7]

		//Box.drawFace(p0,p1,p2,p3, _colors[0]) // front
		//Box.drawFace(p4,p5,p6,p7, _colors[1]) // back
		//Box.drawFace(p3,p2,p5,p4, _colors[4]) // top
		//Box.drawFace(p0,p1,p6,p7, _colors[5]) // bottom
		//Box.drawFace(p1,p6,p5,p2, _colors[2]) // right
		//Box.drawFace(p7,p0,p3,p4, _colors[3]) // left

		Box.drawLine(p0, p1)
		Box.drawLine(p1, p2)
		Box.drawLine(p2, p3)
		Box.drawLine(p3, p0)

		Box.drawLine(p4, p5)
		Box.drawLine(p5, p6)
		Box.drawLine(p6, p7)
		Box.drawLine(p7, p4)

		Box.drawLine(p0, p7)
		Box.drawLine(p1, p6)
		Box.drawLine(p2, p5)
		Box.drawLine(p3, p4)

		//Box.drawPoint(p0)
		//Box.drawPoint(p1)
		//Box.drawPoint(p2)
		//Box.drawPoint(p3)

		//Box.drawPoint(p4)
		//Box.drawPoint(p5)
		//Box.drawPoint(p6)
		//Box.drawPoint(p7)
	}

	static drawPoint (p) {
		
		var W = Draw.width  / 2
		var H = Draw.height / 2

		var X = Draw.width
		var Y = Draw.height

		var x = W + p.x * X // p.z
		var y = H + p.y * Y // p.z

		TIC.circ(x,y, 3, 6)
	}

	static drawLine (p0, p1) {

		var W = Draw.width  / 2
		var H = Draw.height / 2

		var X = Draw.width
		var Y = Draw.height

		var x0 = W + p0.x * X // p0.z
		var y0 = H + p0.y * Y // p0.z
		var x1 = W + p1.x * X // p1.z
		var y1 = H + p1.y * Y // p1.z

		TIC.line(x0,y0, x1,y1, 15)

	}

	// given projected points, draw a face
	static drawFace(p0, p1, p2, p3, color) {
		var W = Draw.width  / 2
		var H = Draw.height / 2

		var X = Draw.width
		var Y = Draw.height

		var x0 = W + p0.x * X // p0.z
		var y0 = H + p0.y * Y // p0.z
		var x1 = W + p1.x * X // p1.z
		var y1 = H + p1.y * Y // p1.z
		var x2 = W + p2.x * X // p2.z
		var y2 = H + p2.y * Y // p2.z
		var x3 = W + p3.x * X // p3.z
		var y3 = H + p3.y * Y // p3.z


		Draw.quad(x0,y0, x1,y1, x2,y2, x3,y3, color)
	}

}

/*
	run 3D math demo
*/
class Game is TIC{

	construct new () {
		_t=0
		_x=0
		_y=0

		_s = 0.1

		_trans   = Matrix.translation(0,0,5)
		_rot     = Matrix.rotationX(Num.pi / 8)
		_project = Matrix.projection(100 * Num.pi / 180, 0.1, 100)

		_box = Box.default()
	}
	
	TIC () {
		TIC.cls(0)

		if(TIC.btn(0)) _y = _y - _s
		if(TIC.btn(1)) _y = _y + _s
		if(TIC.btn(2)) _x = _x - _s
		if(TIC.btn(3)) _x = _x + _s
		
		_t = _t + 1

		var trans = Matrix.translation(0,0,5 + (_t * 0.05).sin * 3)
		var rotY = Matrix.rotationY(_t * Num.pi / 180)
		var rotX = Matrix.rotationX(_t * Num.pi / 180)
		var m = _project * trans * rotX * rotY

		_box.render(m)
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

