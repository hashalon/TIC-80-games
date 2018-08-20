/*
	Entry point of the program
*/
class Game is TIC{

	construct new () {
		// initialize elements
		Ball.Init()
		RugbyMan.Init()


		
		//_camera = Camera.new(p, -Num.pi / 8, 8, 2, 0.65)
		//_camera = Camera.new(p, -Num.pi / 4, 8, 10, 0.5)

		_camera = Camera.new(Vector.new(0, 7, -4), -Num.pi / 4, 10, 1, 0.5)
		_stadium = Stadium.new(_camera, 1, 100, 5, 2)

		var ball = Ball.new(Vector.new(0, 3, 0), 1, 0.9)
		var man  = RugbyMan.new(Vector.new(3, 3, 0), false, 3, 3, 5)
		_stadium.add(ball)
		_stadium.add(man)

		man.player = _stadium[0]

		_t = 0



	}
	
	TIC () {
		TIC.cls(13)

		//_camera.tilt = _camera.tilt + 0.01
		//_camera.mix = Num.pi / 8 + _t.sin * 0.05
		//_stadium.depth = (_t.sin * 10).abs
		//TIC.print(_stadium.depth)
		//_camera.nearPlane = (_t.sin).abs
		_camera.position.x = _t.sin * 10
		_t = _t + 0.001

		/*
		for (i in 0...10) {
			var p1 = Vector.new(-10, 0, -5 + i)
			var p2 = Vector.new( 10, 0, -5 + i)

			var t1 = _camera.transform(p1)
			var t2 = _camera.transform(p2)

			TIC.trace("%(t1.x), %(t1.y), %(t1.z)")

			TIC.line(t1.x, t1.y, t2.x, t2.y, 15)
		}
		// */

		//var p = _camera.transform(Vector.zero())
		//TIC.trace("%(p.x), %(p.y), %(p.z)")


		//Draw.trapezoid(t1.x,t1.y, t2.x,t2.y, t3.x,t3.y, t4.x,t4.y, 15)

		_stadium.update()
		_stadium.draw()

		//Draw.ellipse(120, 50, 10, 5, 0)
	}
}
