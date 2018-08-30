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


