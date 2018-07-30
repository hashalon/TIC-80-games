-- title:  game title
-- author: game developer
-- desc:   short description
-- script: lua
-- pal: 000000111111222222333333444444555555666666777777888888999999AAAAAABBBBBBCCCCCCDDDDDDEEEEEEFFFFFF

cls()

grad3 = {
    {-1,1,0},{1,-1,0},{-1,-1,0},
    {1,0,1},{-1,0,1},{1,0,-1},{-1,0,-1},
    {0,1,1},{0,-1,1},{0,1,-1},{0,-1,-1}
}
grad3[0] = {1,1,0}

permutation = { -- Hash lookup table as defined by Ken Perlin.
    160,137,91,90,15,
	131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
	190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
	88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
	77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
	102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
	135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
	5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
	223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
	129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
	251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
	49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
	138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180
}
permutation[0] = 151

p = {}
for x = 0, 512-1 do
    p[x] = permutation[x & 255]
end

function dot(g, x, y)
    return g[1] * x + g[2] * y
end

function noise(xin, yin)
    local n0, n1, n2

    local F2 = (math.sqrt(3) - 1) / 2
    local s = (xin + yin) * F2
    local i = math.floor(xin + s)
    local j = math.floor(yin + s)

    local G2 = (3 - math.sqrt(3)) / 6
    local t = (i+j) * G2
    local X0 = i - t
    local Y0 = j - t
    local x0 = xin - X0
    local y0 = yin - Y0

    local i1, j1
    if x0 > y0 then i1 = 1 ; j1 = 0 else i1 = 0 ; j1 = 1 end
    
    local x1 = x0 - i1 + G2
    local y1 = y0 - j1 + G2
    local x2 = x0 - 1 + 2 * G2
    local y2 = y0 - 1 + 2 * G2

    local ii = i & 255
    local jj = j & 255
    local gi0 = p[ii + p[jj]]           % 12
    local gi1 = p[ii + i1 + p[jj + j1]] % 12
    local gi2 = p[ii + 1 + p[jj + 1]]   % 12

    local t0 = 0.5 - x0 * x0 - y0 * y0
    if t0 < 0 then n0 = 0 else
        t0 = t0 * t0
        n0 = t0 * t0 * dot(grad3[gi0], x0, y0)
    end

    local t1 = 0.5 - x1 * x1 - y1 * y1
    if t1 < 0 then n1 = 0 else
        t1 = t1 * t1
        n1 = t1 * t1 * dot(grad3[gi1], x1, y1)
    end

    local t2 = 0.5 - x2 * x2 - y2 * y2
    if t2 < 0 then n2 = 0 else
        t2 = t2 * t2
        n2 = t2 * t2 * dot(grad3[gi2], x2, y2)
    end

    return 70 * (n0 + n1 + n2)
end

X = 0
Y = 0
function draw()
    local width, height = 240, 136
    for x = 0, width  - 1 do
    for y = 0, height - 1 do
        local val0 = (noise((x+X  )/50, (y+Y  )/50)+1)*4
        local val1 = (noise((x+X/2)/ 5, (y+Y/2)/ 5)+1)*2
        local val2 = (noise( x+X/4    ,  y+Y/4    )+1)
								
        pix(x, y, (val0 + val1 + val2)*1.2)
    end end
end
draw()

-- run once
function TIC()
    X = X + 1
    Y = Y + 1
    if btnp(0) then draw() end
end

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
-- 000:000000111111222222333333444444555555666666777777888888999999aaaaaabbbbbbccccccddddddeeeeeeffffff
-- </PALETTE>

