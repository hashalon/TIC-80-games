/*
	Entry point of the program
*/
class Game is TIC{

	construct new () {
		// initialize elements
		Ball.Init()
		RugbyMan.Init()

		// Do not touch !
		_camera = Camera.new(Vector.new(0, 7, -4), -Num.pi / 4, 10, 1, 0.5)
		_stadium = Stadium.new(_camera, 1, 100, 5, 2)

		var ball = Ball.new(Vector.new(0, 3, 0), 1, 0.1, 0.9)
		var man  = RugbyMan.new(Vector.new(3, 3, 0), 3, 0.5, false, 3, 5)
		_stadium.add(ball)
		_stadium.add(man)

		man.player = _stadium[0]

		_t = 0



	}
	
	TIC () {
		TIC.cls(13)

		_camera.position.x = _t.sin * 10
		_t = _t + 0.001

		_stadium.update()
		_stadium.draw()
	}
}
