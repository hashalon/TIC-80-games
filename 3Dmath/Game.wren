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

