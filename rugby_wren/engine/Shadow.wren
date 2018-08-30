/*
	a shadow to render under the object
*/
class Shadow {
	
	radius {_radius}
	color  {_color}

	// define an ellipse shape and a color
	construct new (radius, color) {
		_radius = radius
		_color  = color
	}

	draw (x, y, tiltSin, scale) {
		var a = (_radius * scale).ceil
		var b = (_radius * scale * tiltSin).ceil
		Draw.ellipse(x, y , a * 2, b * 2, _color)
	}

}

