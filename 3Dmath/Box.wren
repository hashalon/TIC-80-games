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

