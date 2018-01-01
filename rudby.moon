-- title:  game title
-- author: game developer
-- desc:   short description
-- script: moon

c_sky  =  13
c_grn1 =   5
c_grn2 =  11
depth  =  80
grnd   = 136-depth
top    =  16
bot    =  32
foot   =   0.04

x = 0

-- perspective rectangle
-- t1-t2
-- | / |
-- b1-b2
pers = (xt1,xt2,yt,xb1,xb2,yb,c) ->
	tri xt1,yt,xt2,yt,xb1,yb,c
	tri xt2,yt,xb1,yb,xb2,yb,c
	return

export TIC=->
	cls 13
	rect 0,grnd,240,136,c_grn1
	x += foot if btn 2
	x -= foot if btn 3
	x %= 2
	-- draw 10 stripes
	for i=-10,10,2
		xt = 120 + (x+i) * top
		xb = 120 + (x+i) * bot
		pers(
			xt, xt+top, grnd,
			xb, xb+bot,  136,
			c_grn2)

-- <TILES>
-- 001:efffffffff222222f8888888f8222222f8fffffff8ff0ffff8ff0ffff8ff0fff
-- 002:fffffeee2222ffee88880fee22280feefff80fff0ff80f0f0ff80f0f0ff80f0f
-- 003:efffffffff222222f8888888f8222222f8fffffff8fffffff8ff0ffff8ff0fff
-- 004:fffffeee2222ffee88880fee22280feefff80ffffff80f0f0ff80f0f0ff80f0f
-- 017:f8fffffff8888888f888f888f8888ffff8888888f2222222ff000fffefffffef
-- 018:fff800ff88880ffef8880fee88880fee88880fee2222ffee000ffeeeffffeeee
-- 019:f8fffffff8888888f888f888f8888ffff8888888f2222222ff000fffefffffef
-- 020:fff800ff88880ffef8880fee88880fee88880fee2222ffee000ffeeeffffeeee
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

