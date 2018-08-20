-- util functions
UTIL =
	-- return the sign of the number
	sign:  (x)    -> x>0 and 1 or x<0  and -1 or 0
	sign2: (x, d) -> x>d and 1 or x<-d and -1 or 0

	-- perspective rectangle
	-- t1-t2
	-- | / |
	-- b1-b2
	trap: (xt1,xt2,yt, xb1,xb2,yb, col) ->
		tri xt1,yt, xt2,yt, xb1,yb, col
		tri xt2,yt, xb1,yb, xb2,yb, col
		return
	
	-- return squared distance between both positions
	sqrDist: (u, v) ->
		X, Y, Z = v.x - u.x, v.y - u.y, v.z - u.z
		return X*X + Y*Y + Z*Z
	
	-- return distance between both positions
	dist: (u, v) -> math.sqrt util.sqrDist(u,v)

	-- render textured rectangle to screen
	-- rectangle is defined as:
	-- (1) 1 --- 2
	--     |  \  |
	--     3 --- 4 (2)
	texrect: (x1, y1, x2, y2, x3, y3, x4, y4, u1, v1, u2, v2, use_map, chroma) ->
		use_map, chroma = use_map or false, chroma or -1
		textri(x1, y1, x2, y2, x4, y4, u1, v1, u2, v1, u2, v2, use_map, chroma)
		textri(x1, y1, x3, y3, x4, y4, u1, v1, u1, v2, u2, v2, use_map, chroma)
		return

	-- draw a sprite on the screen with the given scale
	-- x, y define the center of the sprite rather than the top left corner
	-- scale is a real number
	-- flip only horizontaly
	-- no rotation
	spr_x: (id, x, y, chroma, scale, flip, w, h) =>
		chroma = chroma or -1
		scale  = scale  or  1
		w, h = w or 1, h or 1

		-- compute offset of x's and y's
		-- (sprite unit = 8, so half is 4)
		w_2, h_2 = w * 4 * scale, h * 4 * scale
		x1, y1 = x - w_2, y - h_2
		x2, y2 = x + w_2, y + h_2

		-- compute uv position
		u1, v1 = (id % 16) * 8, (id // 16) * 8
		u2, v2 =    u1 + w * 8,     v1 + h * 8

		-- crop the sprite
		u1 += 0.5
		v1 += 0.5
		u2 -= 0.5
		v2 -= 0.5

		if flip -- flip sprite
			@.texrect(x1, y1, x2, y1, x1, y2, x2, y2, u2, v1, u1, v2, false, chroma)
		else -- do not flip sprite
			@.texrect(x1, y1, x2, y1, x1, y2, x2, y2, u1, v1, u2, v2, false, chroma)
		return

	-- draw a simple horizontal ellipse
	ellipse: (x, y, a, b, col) ->
		-- compute helper variables
		a_2, b_2 = a/2, b/2

		-- iterate over each pixel of the rectangle
		for i = -a_2, a_2 do for j = -b_2, b_2 do
			x_, y_ = i / a_2, j / b_2
			if x_*x_ + y_*y_ <= 1
				pix x+i, y+j, col

-- END UTIL --


