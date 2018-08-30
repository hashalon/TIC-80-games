/*
	Stadium for our game
*/
class Stadium is World {
	
	static white  {15}
	static green1  {5}
	static green2 {11}

	static camSpeed {10}

	/* GETTERs */
	width  {_width }
	depth  {_depth }
	stripe {_stripe}

	ball {_ball}

	/* SETTERs */
	width  =(w) {_width  = w}
	depth  =(d) {_depth  = d}
	stripe =(s) {_stripe = s}

	construct new (camera, nb_players, width, depth, stripe) {
		super(camera, nb_players)

		_width  = width
		_depth  = depth
		_stripe = stripe

		_ball = null
	}

	// make the camera follow the ball
	update () {
		super.update()

		if (_ball != null && !camera.inField(_ball.position.x)) {
			var vel = _ball.velocity.x
			if      (vel < -Stadium.camSpeed) {vel = -Stadium.camSpeed}
			else if (vel >  Stadium.camSpeed) {vel =  Stadium.camSpeed}
			camera.position.x = camera.position.x + vel / Draw.FPS
		}
	}

	add (entity) {
		if (entity is Ball) {_ball = entity}
		super.add(entity)
	}

	// draw the stadium then the objects in it
	draw () {
		// draw green strippes
		var cx = camera.position.x
		var cf = camera.field
		var d  = _depth / 2
		var nbSteps = (2 * camera.field / _stripe).ceil

		// prepare starting point
		var x = (cx - cf) - (cx % _stripe)
		var c = (x % (_stripe * 2)) == 0
		//TIC.trace(x)

		// prepare the two first points
		var p1 = camera.transform(Vector.new(x, 0, -d))
		var p2 = camera.transform(Vector.new(x, 0,  d))

		//TIC.trace(p1.x)
		for (str in 0...nbSteps) {
			// prepare two second points
			x = x + _stripe
			var p3 = camera.transform(Vector.new(x, 0, -d))
			var p4 = camera.transform(Vector.new(x, 0,  d))

			var color = c ? Stadium.green1 : Stadium.green2
			Draw.trapezoid(p1.x,p1.y, p2.x,p2.y, p4.x,p4.y, p3.x,p3.y, color)

			// shift points
			p1 = p3
			p2 = p4
			c = !c
		}

		// trace border lines
		var line1 = camera.transform(Vector.new(x, 0, -d))
		var line2 = camera.transform(Vector.new(x, 0,  d))
		TIC.rect(0, line1.y, Draw.width, 1, Stadium.white)
		TIC.rect(0, line2.y, Draw.width, 1, Stadium.white)

		super.draw()
	}

}