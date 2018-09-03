/*
	List of sprites to render an entity
*/
class Sprite {
	
	/* GETTERs */
	[index] {_ids[index]}

	width  {_width }
	height {_height}
	scale  {_scale }

	/* CONSTRUCTORs */
	// provide a list of ids, the size of the sprites and the background color
	construct new (ids, width, height, scale, background) {
		// generate list of uv coordinates
		_ids = ids
		_coords_u = []
		_coords_v = []
		for (id in ids) {
			_coords_u.add((id % 16)       * 8)
			_coords_v.add((id / 16).floor * 8)
		}

		_width  = width
		_height = height
		_scale  = scale

		_background = background

	}

	/* METHODs */
	draw (id, x, y, scale, flip) {
		// prepare texture coordinates
		var u1 = _coords_u[id]
		var v1 = _coords_v[id]
		var u2 = u1 + _width
		var v2 = v1 + _height

		// prepare drawing coordinates
		var w = _width  * _scale * scale / 2
		var h = _height * _scale * scale / 2
		var x1 = x - w
		var y1 = y - h
		var x2 = x + w
		var y2 = y + h

		// flip the sprite
		if (flip) {
			var tmp = u1
			u1 = u2
			u2 = tmp
		}

		// draw the sprite
		Draw.texrect(x1, y1, x2, y2, u1, v1, u2, v2, false, _background)
	}
}

