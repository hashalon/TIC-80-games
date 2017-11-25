-- title:  rudby game
-- author: Olivier Schyns
-- desc:   2 players rudby game
-- script: moonscript

--HELPERs--

sign=(x)-> x>0 and 1 or x<0 and -1 or 0
siga=(x,d)->
	x>d and 1 or x<-d and -1 or 0

null=(x,d)-> -d<x and x<d
nadd=(a,b)->
	return a+b if sign(a)~=sign(b)
	a

cap=(x,c)->
	if     x<-c then x=-c
	elseif x> c then x= c
	x

dist=(x0,y0,z0,x1,y1,z1)->
	X,Y,Z = x1-x0 , y1-y0 , z1-z0
	X*X+Y*Y+Z*Z , X,Y,Z

zOrder=(a,b)-> a.pz>b.pz

--search index of element in list
search=(l,v)->
	for i=1,#l do return i if l[i]==v
	nil
	
--CLASSES--

class Env
	env: Env 6,300,200
	
	new:(nb,dw,dh)=>
		@dw,@dh = dw,dh
		@ch,@bl = {},nil
		-- TODO place players
		for n=0,nb
			@add Char @dw  /4,100,@dh/2,false
			@add Char @dw*3/4,100,@dh/2,true
	
	add:(ch)=> @ch[ch]=true
	rem:(ch)=> @ch[ch]=nil
	
	updt:=>
		@bl=Ball @dw/2,100,@dh/2 if @bl==nil
		ch\updt! for ch in pairs @ch
	
	grnd:(x,z)=> 0
	bond:(x,z)=>
		if     z<0   then z=0
		elseif z>@dh then z=@dh
		if     x<0   then x=0
		elseif x>@dw then x=@dw
		x,z


class Char
	spd: 2
	jmp: 4
	
	new:(x,y,z,tm)=>
		@px,@py,@pz = x,y,z
		@vx,@vy,@vz = 0,0,0
		@tm,@fr = tm,tm
		@pl = nil
	
	updt:=>
		u,v,a,b = @inpt!
		if @grnd! -- on ground
			@vx = @vx/2 + u*@@spd
			@vy = @@jmp if a
			@vz = @vz/2 + v*@@spd
		else -- in the air
			@vx = @cap @vx,u
			@vz = @cap @vz,v
		-- apply velocity
		@px+= @vx
		@py+= @vy
		@pz+= @vz
		@px,@pz = Env.env\grnd @px,@pz
		
	grnd:=> @py<=0
	inpt:=>
		return @pl\inpt! if @pl~=nil
		-- TODO
		return 0,0,false,false
	@cap:(v,i)-> cap v+i*@@spd*.1,@@spd*2


class Ball
	new:(x,y,z)=>
		@px,@py,@pz = x,y,z
		@vx,@vy,@vz = 0,0,0
		
	updt:=>
		-- apply velocity
		@px+= @vx
		@py+= @vy
		@pz+= @vz


class Play
	new:(tm)=>
		

export TIC=->
-- <PALETTE>
-- 000:140c1c44243430346d4e4a4e854c30346524d04648757161597dced27d2c8595a16daa2cd2aa996dc2cadad45edeeed6
-- </PALETTE>

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

