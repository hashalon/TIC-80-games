-- title:  Voronoid
-- author: Olivier Schyns
-- desc:   Draw Voronoid graph
-- script: moonscript

-- change the distance function to
-- change the look of the diagram

EUCLIDEAN=(x1,y1,x2,y2)->
	dx = x1-x2
	dy = y1-y2
	return math.sqrt(dx*dx + dy*dy)
	
MANHATTAN=(x1,y1,x2,y2)->
	dx = math.abs(x1-x2)
	dy = math.abs(y1-y2)
	return dx + dy

CHEBYSHEV = (x1,y1,x2,y2)->
	dx = math.abs(x1-x2)
	dy = math.abs(y1-y2)
	return math.max(dx,dy)

MIX = (x1,y1,x2,y2)->
	a = CHEBYSHEV(x1,y1,x2,y2)
	b = MANHATTAN(x1,y1,x2,y2)
	return a + b*2

DISTANCE = MIX

WIDTH  = 240
HEIGHT = 136
TIMER  =  10

-- disable timer because it 
-- use too much ressources
USE_TIMER = false

-- setup random generator
--math.randomseed os.time!

-- point in the 2D space
class Point
	new:(c)=>
		@x = math.random 0,WIDTH
		@y = math.random 0,HEIGHT
		@c = c
	
	-- return the manhattan distance from the point
	distance:(x,y)=>
		return DISTANCE @x,@y,x,y

-- build a point for each color
POINTS = [Point(c) for c = 1,14]

-- return the closest point
closest = (x,y) ->
	d1 = WIDTH+HEIGHT --infinity
	p1 = nil          --no point selected
	for p2 in *POINTS  --test each point
		d2 = p2\distance x,y
		if d2 < d1 --point is closer
			d1 = d2
			p1 = p2
	return p1

-- draw the diagram
drawTerritories=->
	-- for each pixel of the screen
	for x = 0,WIDTH
		for y = 0,HEIGHT
			-- select the color of the pixel
			c = closest(x,y).c
			pix x,y,c

drawPoints=->
	-- draw the points too
	for p in *POINTS
		spr 1,p.x-4,p.y-4,14

drawTerritories!

-- state
t = 0
was_pressed = false

export TIC=->
	-- redraw the whole territories
	-- each time the timer reach 0
	if USE_TIMER
		t -= 1
		if t <= 0
			t = TIMER
			drawTerritories!
	
	-- interact with the mouse
	x,y,press = mouse!
	if press
		p = closest x,y
		p.x = x
		p.y = y
		was_pressed = true
	else
		-- released the mouse button
		if was_pressed
			drawTerritories!
		was_pressed = false
	
	drawPoints!
	return
	

-- <TILES>
-- 001:eeffffeeef0000fef0eeee0ff0eeee0ff0eeee0ff0eeee0fef0000feeeffffee
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <PALETTE>
-- 000:140c1c44243430346d4e4a4e854c30346524d04648757161597dced27d2c8595a16daa2cd2aa996dc2cadad45edeeed6
-- </PALETTE>

