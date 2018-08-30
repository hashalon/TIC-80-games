/*
	contains functions to draw stuff
*/
class Draw {
	
	// size of the screen
	static width  {240}
	static height {136}
	static FPS    { 60}

	// draw a rectangle from spritesheet or map
	static texrect (
		x1, y1, x2, y2, x3, y3, x4, y4, 
		u1, v1, u2, v2, 
		use_map, chroma) {
		TIC.textri(
			x1, y1, x2, y2, x4, y4, 
			u1, v1, u2, v1, u2, v2, 
			use_map, chroma)
		TIC.textri(
			x1, y1, x3, y3, x4, y4,
			u1, v1, u1, v2, u2, v2,
			use_map, chroma)
	}
	static texrect (
		x1, y1, x2, y2,
		u1, v1, u2, v2, 
		use_map, chroma) {
		TIC.textri(
			x1, y1, x2, y1, x2, y2, 
			u1, v1, u2, v1, u2, v2, 
			use_map, chroma)
		TIC.textri(
			x1, y1, x1, y2, x2, y2,
			u1, v1, u1, v2, u2, v2,
			use_map, chroma)
	}

	// draw ellipse line by line
	static ellipse (x, y, a, b, color) {
		x = x.round
		y = y.round
		a = a.ceil
		b = b.ceil

		// prepare values
		var x1 = x - a
		var y1 = y - b
		var x2 = x + a
		var y2 = y + b

		var a2 = a * a
		var b2 = b * b

		y1 = y1.floor
		y2 = y2.ceil

		for (i in y1..y2) {
			// solve ellipse-line intersection equation
			var dist = i - y
			var q = (((1 - dist * dist / b2) * a2).sqrt).ceil
			TIC.rect(x - q, i, q * 2, 1, color)
		}
	}

	static trapezoid (x1,y1, x2,y2, x3,y3, x4,y4, color) {
		TIC.tri(x1,y1, x2,y2, x3,y3, color)
		TIC.tri(x1,y1, x3,y3, x4,y4, color)
	}
}

