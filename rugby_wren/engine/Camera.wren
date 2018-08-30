/*
	Define the zone that is visible and apply transformations to objects
*/
class Camera {
	
	/* GETTERs */
	position   {_position  }
	tilt       {_tilt      }
	orthoScale {_orthoScale}
	nearPlane  {_nearPlane }
	mix        {_mix       }
	field      {_field     }

	/* SETTERs */
	position  =(p) {_position.copy(p)}
	nearPlane =(n) {_nearPlane = n}
	mix       =(m) {_mix       = m}

	orthoScale =(s) {
		_orthoScale = s
		_field = 1.5 * Draw.width / _orthoScale
	}

	tilt=(t) {
		_tilt = t
		_tiltSin = (-_tilt).sin
		_tiltCos = (-_tilt).cos
	}

	/* CONSTRUCTORs */
	// initial position of the camera, tilt in radian,
	// orthographic scale, near plane distance, 
	// mix between orthographic and perspective
	construct new (position, tilt, orthoScale, nearPlane, mix) {
		_position   = position.clone()
		_tilt       = tilt       // rotation
		_orthoScale = orthoScale // orthographic scale
		_nearPlane  = nearPlane  // frustrum near place
		_mix        = mix        // transform mix

		// precompute
		_tiltSin = (-_tilt).sin
		_tiltCos = (-_tilt).cos

		_field = 1.5 * Draw.width / _orthoScale
	}

	// transform a point to render it on the screen
	transform (point) {
		// rotate point in camera space
		var vec = point - _position
		var z = vec.z * _tiltCos - vec.y * _tiltSin
		var y = vec.z * _tiltSin + vec.y * _tiltCos
		//TIC.trace("%(z), %(y)")

		// get transformed point with an orthographic and a perspective camera
		var ortho = orthoTransform(vec.x, y, z)
		var persp = perspTransform(vec.x, y, z)

		// mix both results to build transformed point
		var out = (ortho * (1 - _mix)) + (persp * _mix)

		// place it in the screen
		out.x = (Draw.width  / 2) + out.x
		out.y = (Draw.height / 2) - out.y
		return out
	}

	// apply orthographic transformation to rotated vector
	orthoTransform (x, y, z) {
		return Vector.new(x * _orthoScale, y * _orthoScale, z)
	}

	// apply perspective transformation to rotated vector
	perspTransform (x, y, z) {
		// http://www.cse.psu.edu/~rtc12/CSE486/lecture12.pdf

		// if too close => bug
		if (z <= 0) return Vector.zero()

		// formula to get projected size
		var s = 100 * _nearPlane / z
		return Vector.new(x * s, y * s, z)
	}

	// given simply the x position, 
	// return true if the position could be seen by the camera
	inField (x) {-_field <= x && x <= _field}

}

