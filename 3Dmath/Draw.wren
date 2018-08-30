/*
	Draw functions
*/

class Draw {
	
	static width  {240}
	static height {136}

	static quad (x1,y1, x2,y2, x3,y3, x4,y4, color) {
		TIC.tri(x1,y1, x2,y2, x3,y3, color)
		TIC.tri(x1,y1, x4,y4, x3,y3, color)
	}

}


