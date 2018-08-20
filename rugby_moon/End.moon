-- create a stadium
stadium = Stadium 1, 100, 8

pos = Vector 50, 0, 4
man1 = RugbyMan stadium, false, pos
man1.player = stadium.players[1]

-- generate characters for each team
for i = 1,4
	pos = Vector 48, 0, i*2
	man = RugbyMan stadium, false, pos
for i = 1,4
	pos = Vector 52, 0, i*2
	man = RugbyMan stadium,  true, pos

-- update the stadium and render
export TIC=->
	stadium\update!
	stadium\render!
	print stadium.ball.pos.x

-- <TILES>
-- 001:00ffff000ffffff0ffffffffffffffffdffffffdddffffdd0dddddd000dddd00
-- 002:fffffffffffffffff000000f0000000000000000f000000fffffffffffffffff
-- 003:fffffffffffff000fff00000ff000000ff000000fff00000fffff000ffffffff
-- 004:ffffffff000fffff00000fff000000ff000000ff00000fff000fffffffffffff
-- 016:efffffffff222222f8888888f8222222f8fffffff8ff0ffff8ff0ffff8ff0fff
-- 017:fffffeee2222ffee88880fee22280feefff80fff0ff80f0f0ff80f0f0ff80f0f
-- 018:efffffffff222222f8888888f8222222f8fffffff8fffffff8ff0ffff8ff0fff
-- 019:fffffeee2222ffee88880fee22280feefff80ffffff80f0f0ff80f0f0ff80f0f
-- 032:f8fffffff8888888f888f888f8888ffff8888888f2222222ff000fffefffffef
-- 033:fff800ff88880ffef8880fee88880fee88880fee2222ffee000ffeeeffffeeee
-- 034:f8fffffff8888888f888f888f8888ffff8888888f2222222ff000fffefffffef
-- 035:fff800ff88880ffef8880fee88880fee88880fee2222ffee000ffeeeffffeeee
-- 048:efffffffff111111f6666666f6111111f6fffffff6ff0ffff6ff0ffff6ff0fff
-- 049:fffffeee1111ffee66660fee11160feefff60fff0ff60f0f0ff60f0f0ff60f0f
-- 050:efffffffff111111f6666666f6111111f6fffffff6fffffff6ff0ffff6ff0fff
-- 051:fffffeee1111ffee66660fee11160feefff60ffffff60f0f0ff60f0f0ff60f0f
-- 064:f6fffffff6666666f666f666f6666ffff6666666f1111111ff000fffefffffef
-- 065:fff600ff66660ffef6660fee66660fee66660fee1111ffee000ffeeeffffeeee
-- 066:f6fffffff6666666f666f666f6666ffff6666666f1111111ff000fffefffffef
-- 067:fff600ff66660ffef6660fee66660fee66660fee1111ffee000ffeeeffffeeee
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