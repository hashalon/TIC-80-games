-- title:  frog catch
-- author: Olivier Schyns
-- desc:   6-players game with frogs
-- script: moon

speed   =   1
jump    =   4
gravity = 0.1
ground  = 109
respawn = 180
counter = 200
timer   =   1 --1:00

--start at zero
colors = {[0]:11,6,8,14,10,15}

--players from 1 to 6
players = {} --list of players
flies   = {} --set  of flies

--shorthand for random function
rand=(l,u)->(u-l)*math.random!+l
flip=->math.random!<.5

--get squared distance between two pts
distSqr=(x0,y0,x1,y1)->
	X = x1-x0
	Y = y1-y0
	X*X + Y*Y

--display the timer
drawTimer=->
	min =  timer//3600
	sec = (timer//60)%60
	sec = "0"..sec if sec<10
	txt = ""..min..":"..sec
	print txt,111,2,      12
	rectb     104,0,34,10,12
	timer -= 1
	timer

--display an effect when a frog die
blows = {}

--create a new blow at the position
createBlow=(x,y,c)->
	blow =
		x: x
		y: y
		c: c
		s: 32
	blows[blow]=true
	sfx 1,95,180,1,10
	blow

--draw blows + shaky effect
drawBlows=->
	blc=0
	--update each blow
	for bl in pairs blows
		bl.s+= 5
		blc += 1
		blows[bl]=nil if bl.s>275
		circb bl.x,bl.y,bl.s,bl.c
	--shake the screen with the blow
	poke 0x03FF9,math.random -1,1 if blc>0
	return

class Frog
	new:(x,y,p)=>
		--position
		@px = x
		@py = y
		--velocity
		@vx = 0
		@vy = 0
		--link player to frog
		@pl    = p
		@pl.fr = @
		--input
		@bt = @pl.n*2
		@bt+= 2 if @pl.n>2
		--sprite
		@sp = @pl.n*2
		@pt = 0 --nb points collected
	
	input:=>(btn @bt),(btn @bt+1)
	
	update:=>
		-- we need the two button pressed
		l,r  = @input!
		grnd = @py>ground
		
		if grnd then
			@vx/= 2
			@vy = 0
			@vx-= speed if l
			@vx+= speed if r
		
		--apply velocity to position
		@px+= @vx
		@py+= @vy
		--apply acceleration to velocity
		@vy+= gravity
		
		--if grounded+both btns pressed->jump
		if grnd then
			@vy-= jump	  if l and r
			@py = ground
		
		--touch fly->points
		for fly in pairs flies
			if 64>distSqr @px,@py,fly.px,fly.py
				flies[fly]=nil --kill fly
				@pt+= fly.pt   --get points
				sfx 0,50,100,0,15
		
		--outbound->death
		if @px<-16 or 256<@px
			@pl.fr = nil    --unlink frog
			@pl.sc+= @pt//2 --only half of points
			createBlow @px,@py,@pl.cl
		return
		
	draw:=>
		--choose the right sprite
		sp  = 256
		sp +=  16 if @py<ground
		sp += @sp --use the color
		
		fl = 0
		fl = 1 if @vx<0 
		
		--draw the frog
		spr sp,@px-8,@py-4,0,1,fl,0,2,1
		return

--end Frog


--point of interest for bots
IX,IY=120,68 --center of screen

--compute the point of interest
findInterest=->
	--average position of the flies
	IX,IY,count = 120,68,1
	for fly in pairs flies
		IX   += fly.px*fly.pt
		IY   += fly.py*fly.pt
		count+= fly.pt
	IX/=count
	IY/=count

class FrogBot extends Frog
	input:=>
		dx = IX-@px
		dy = IY-@py
		l,r= (dx<0),(dx>0)
		l=not l if math.random!<.1
		r=not r if math.random!<.1
		l,r

--end FrogBot


class Player
	new:(n,b)=>
		@n  = n   --# of player
		@b  = b   --is it a bot?
		@fr = nil --frog
		@sc = 0   --score
		@ct = 0   --respawn counter
		@cl = colors[@n] --get color
		players[@n] = @
	
	update:=>
		if @fr==nil --frog died
			@ct-= 1
			if @ct<=0 --respawn
				@ct = respawn
				x = rand 10,230
				if @b then @fr = Frog x,60,@
				else @fr = FrogBot x,60,@
		return
	
	draw:=>
		--draw the scores in the top
		--40pix for each player
		pd = @n*40+5
		--score printed
		sc  = @sc
		sc += @fr.pt if @fr~=nil
		sc  = ""..sc
		sc..= "!"    if @fr==nil 
		print sc,pd,12,@cl
		return

--end Player


class Fly
	new:(x,y,n,s,a)=>
		--position
		@px = x
		@py = y
		--velocity
		@vx = if x>120 then -s else s
		@vy = 0
		--type of fly
		@n  = n
		@pt = 10*math.floor math.exp n
		--animation
		@am = a --amplitude
		@a  = 0 --frame
		@t  = 0 --period
		--add the fly to the list
		flies[@]=true
	
	update:=> 
		--apply velocity to position
		@px += @vx
		@py += @vy
		--apply acceleration to velocity
		@vy = @am*math.sin @t
		@t += 0.1
		--outbound->death
		if @px<-8 or 248<@px
			flies[@]=nil
		return
		
	draw:=>
		--make the fly flap its wings
		@a+= 0.5
		@a%= 4
		spr 304+@n,@px-4,@py-4,0,1,@a,0,1,1
		return

--end Fly


--counter for next fly spawn
cnt = counter

createFly=->
	ty = rand 0,(rand 0,5) --type
	x  = if flip! then 0 else 240
	y  = rand 5,60
	sp = rand .5,2
	am = rand .5,2
	Fly x,y,ty,sp,am


--draw the environment
bubbles = {}

createBubble=->
	bubble =
		x: rand 0,240
		y: 136
		s: rand 2,5
		v: rand .1,.5
	
	bubbles[bubble]=true
	bubble

createBubble! for i=0,10 --10 bubbles

drawEnv=->
	--update each bubble
	for bub in pairs bubbles
		bub.y -= bub.v
		circb bub.x,bub.y,bub.s,2
		--replace bubble when reach top
		if bub.y<0
			createBubble!
			bubbles[bub]=nil
	
	--draw the ground
	map 0,0,15,3,  0,ground+3
	map 0,0,15,3,120,ground+3
	return


--main gameloop
UPDATE=->
	cls!
	drawBlows!
	drawEnv!
	drawTimer!
	
	--update each frog
	for n,player in pairs players
		player\update!
		player\draw!
		frog = player.fr
		if frog ~= nil
			frog\update!
			frog\draw!
	
	--update each fly
	for fly in pairs flies
		fly\update!
		fly\draw!
	
	--create more flies
	cnt-= 1
	if cnt<=0
		createFly! for i=0,rand 1,4
		cnt = rand 0,counter
	
	--update point of interest
	findInterest!
	return

--are we in the menu?
menu =
	list:  {[0]:1,2,1,0,0,0}
	label: {[0]:"empty","computer","human"}
	length:{}
	cursor:0
	timer: 2 --2:00
	play:
		txt: "play"
		pos: 120
	title:
		txt: "FROG CATCH"
		pos: 120

--we need the length of the labels
for i=0,2
	menu.length[i]=(print menu.label[i])-10
menu.play.pos = 125-(
	print menu.play.txt)/2
menu.title.pos= 128-(
	print menu.title.txt,0,0,11,false,3)/2

--menu interaction
MENU=->
	cls!
	drawEnv!
	
	--print the title
	print(menu.title.txt,
		menu.title.pos+2,12, 5,false,3)
	print(menu.title.txt,
		menu.title.pos  ,10,11,false,3)
	
	--draw list: empty|computer|human
	for i=0,5
		val = menu.list[i]
		txt = menu.label[val]
		len = menu.length[val]
		y   = 36+i*8
		print txt,120-len/2,y,colors[i]
		
		--print arrows
		if menu.cursor==i
			sp = 288+i*2
			spr sp  , 90,y,0
			spr sp+1,150,y,0
	
	--print timer
	cl = 4
	if menu.cursor==6
		cl = 12
		spr 300, 90,90,0
		spr 301,150,90,0
	min = math.floor  menu.timer
	sec = math.floor (menu.timer-min)*60
	sec = "0"..sec if sec<10
	tim = ""..min..":"..sec
	print tim,menu.play.pos,90,cl
	
	--print play button
	cl = 4
	if menu.cursor==7
		cl = 12
		spr 300, 90,100,0
		spr 301,150,100,0
	print(menu.play.txt,
		menu.play.pos,100,cl)
	
	--move the cursor
	menu.cursor-= 1 if btnp 0
	menu.cursor+= 1 if btnp 1
	menu.cursor = 0 if menu.cursor<0
	menu.cursor = 7 if menu.cursor>7
	
	--play
	if menu.cursor==7
		if (btnp 2)or(btnp 3)
			for i=0,5
				switch menu.list[i] --if 0 -> empty
					when 1 then Player i      --bot
					when 2 then Player i,true --human
			--make the timer usable
			timer = math.floor menu.timer*3600
			menu  = nil
	--or change state of player
	else
		dir = menu.list[menu.cursor] or 0
		dir-= 1 if btnp 2
		dir+= 1 if btnp 3
		--change timer
		if menu.cursor==6
			menu.timer+= dir/2
			menu.timer = .5 if menu.timer<.5
			menu.timer =  5 if menu.timer> 5
		--or apply changes to list
		else menu.list[menu.cursor]=(dir+3)%3
	return

--list of players on the podium
podium = nil

--get player with highest score
getGreatest=->
	tar = nil
	for n,pl in pairs players
		if tar==nil then tar=pl
		elseif tar.sc<pl.sc
			tar=pl
	tar

--assign a position on the podium
assignPod=(p,x,y)->
	pl = podium[p]
	if pl~=nil
		pl.x = x
		pl.y = y
	pl

--generate the podium
genPodium=->
	podium = {}
	--init the scores
	for n,pl in pairs players
		--add the points of the frog
		pl.sc+= pl.fr.pt if pl.fr~=nil
		pl.fr = nil
	--add the 3 firsts to the podium
	for i=1,6
		pl=getGreatest!
		players[pl.n]=nil if pl~=nil
		podium[i]=pl
	--generate frogs to draw
	assignPod 1,112,ground-20
	assignPod 2, 96,ground-16
	assignPod 3,128,ground-12
	assignPod 4, 80,ground-4
	assignPod 5,144,ground-4
	assignPod 6, 64,ground-4
	return
		

--end of game
END=->
	--generate the podium once!
	genPodium! if podium==nil
	--draw the map
	cls!
	drawEnv!
	map 0,4,6,2,96,ground-12,0
	--draw the frogs on the podium
	for i=1,#podium
		pl = podium[i]
		spr pl.n*2+256,pl.x,pl.y,0,1,0,0,2,1
		--draw the score board
		cl  = colors[pl.n]
		txt = ""..pl.sc
		len = #(txt)*6
		print txt,129-len,12+i*8,cl,true
	return

export TIC=->
	if     menu~=nil then MENU!
	elseif timer>0   then UPDATE!
	else                  END!
	return

-- <PALETTE>
-- 000:140c1c44243430346d4e4a4e854c30346524d04648757161597dced27d2c8595a16daa2cd2aa996dc2cadad45edeeed6
-- </PALETTE>

-- <TILES>
-- 016:9e9efeff99eeefff9e9efeff99eeefff9e9efeff99eeeff99e9efe9f99eee9ff
-- 017:fffeee99ffefe9e9fffeee99ffefe9e9fffeee9999efe9e9f9feee99f9efe9e9
-- 018:00000000000000000000000000000000adadfdffaadddfaaadadfaffaaddafff
-- 019:00000000000000000000000000000000fffdddaaaadfdadaffadddaafffadada
-- 032:9e9e9fff99ee999f9e9efe9f99eeef9f9e9e999f99ee9fff9e9e999999eeefff
-- 033:f9feee99f9efe9e9f9feee99f9efe9e9f999ee99fff9e9e99999ee99ffefe9e9
-- 034:adadaffaaadddaaaadadfdafaadddaffadadafffaaddafffadadaaaaaadddfff
-- 035:affaddaafffadadaffadddaafadfdadaaaaaddaafffadadaaaaaddaaffdfdada
-- 036:4949c9cc44999cc14949c91c44999ccc4949cccc44999c1c4949c9c144999ccc
-- 037:ccc999441c9c9494c1c999441c9c9494c1c99944c19c94941cc99944cc9c9494
-- 208:00000000555555555b555b555bb55bb55bb555b55bbb55bb55bbb5bb55b5b55b
-- 209:0000000055555555bb555b555b55bb5555b55bbb555b55b5b5bbb5b5b55bb5b5
-- 210:0000000055555555b555bb55bb55bbb5bb5555b5b5b5bbb5bbb55b5b5bb55b5b
-- 211:0000000055555555b55b55bbbbbbbbbbbbb5bbb5bbb55bb5bbb55b5b5bb55b5b
-- 212:0000000055555555b55bb55bb55bb55bb55bbb5bbb5b5bbb5bbb55bbbbbbb5bb
-- 213:00000000555555555b555b55bbb55b55b5bb5bb5b5bb5bb5b5b55bb5bb5b5bb5
-- 214:00000000555555555555b555b5bbb555b5bb5b55b5bb5b55b5bbbbb5b5b5b5b5
-- 215:0000000055555555bbb555b5bbb55bbbbbbb5bbbbbbbbbbbb5bbb5bbbbb5b5bb
-- 216:00000000555555555b5bb5bb5b5bb55bbbb5bb5bb5b5bb55b5b5b5b5b5b55b55
-- 217:0000000055555555b55555b5b55b55b5bb55b5b5bbb5b5bb5bb55b5b5b5b5bbb
-- 218:0000000055555555b55b55b5bb5b55bbbb5bb5bbbb5bb5bbbb5bb5bbb5bb5b5b
-- 219:0000000055555555b55b55bbbb5b55bb5b5bb5bb5b5bb5b55b55b5b555bbbbb5
-- 220:000000005555555555b5bb555bb5bbbbbbbbbb5bbbbbb5bbbbbbb5b5bbb5b5b5
-- 221:00000000555555555b5b5b55b55b5bb55b5bb5b5b5bbbbbbb5bbbbbb5b5bb5bb
-- 222:00000000555555555555b5b5bbb5b5b55bb5b5b55bbbbb5b555bb5bb5b5bb5b5
-- 223:00000000555555555bb5b5b55bb5bbb55bb55bbb5bb55b5b5b555bbb55bb5bbb
-- 224:55bbb55b55bbbb5b111b5b55111b55b5111b11b1111111111111111111111111
-- 225:bb5bb5bb5b5bb55bbbbb5b5bbb1b5b5bbb1b1b1b111111111111111111111111
-- 226:5bb5b55b5bb5bb5b1bb11b5b11bb1bbb11bb11b1b11111111111111111111111
-- 227:5bb55bb55bbb55b55bbb11b511b1b1bb11b1b11b111111111111111111114111
-- 228:bbb5b5b5bbbbb1b55b5b11b55b5bb1b11b11b1111111b1111111111111111111
-- 229:bb5bbbbb5b55bb5b55b1bb5b11b11b1b11b11b1b111111111111114111111111
-- 230:bbb5b5b55bb1bbbb5bb11b1b11b11bbb11b11bb1111111111111111111111111
-- 231:b5b5bbbbb5b55bbbb5bb5bb5b5bb5bb1b1bb11b1111111111111111111111111
-- 232:b5bbbbb5bb1bbbbbbb1b555b1b1bbb111b11b111111111111111111111111114
-- 233:5bbbb5bb51bbb5bb1bb1bbbb11b1bb1b11b11111111111111111111111111111
-- 234:b5bb5b5bb5bb55bbb55bb5bbbb5bb1b1bb1bb111111111111111111111111411
-- 235:11bb5bb5b1bb5bb5b1bb5bb1b1bb1111111b1111111111111111111111111111
-- 236:b5b5bbb5bbb5bbb51b5bb1b11b5bb1b11b111111111111111111111111141111
-- 237:bbb5bbbb55b5bbbbbb5bbb1b5b5bbb1511b1b1111111b1111111111141111111
-- 238:bb55b5bbbb55bb1bbb511b115b511b111b111111111111111111111111111111
-- 239:b55b5b5bbbbbb55b5bb5bb5b5bb5bb1b11b11b1b111111111111111111114111
-- 240:1111411111111111111111111111111111111111111411111111111111111111
-- 241:1111111111111411111111111111111111111111411111111111111111111111
-- 242:1111111411111111111111111111111111111111411111111111111111111111
-- 243:1111111111111111111111111111111111111111114111111111111111111111
-- 244:1111111111111111111111111141111111111111111111111111111111111111
-- 245:1111111111111111411111111111111111111111111111111111141111111111
-- 246:1111111111411111111111111111111111111111111111141111111111111111
-- 247:1111411111111111111111111111111111111111111111111111111111111111
-- 248:1111111111111111111111111111111114111111111111111111111111111111
-- 249:1111111111111114111111111111111111111111141111111111111111111111
-- 250:1111111111111111111111111111111111111111111111111111111111111111
-- 251:1111111114111111111111111111111111111111111111114111111111111111
-- 252:1111111111111111111111111111111111111111141111111111111111111111
-- 253:1111111111111111111111114111111111111111111111111114111111111111
-- 254:1411111111111111111111111111111111111111111111111114111111111111
-- 255:4111111111111111111111111111111111111141111111111111111111111111
-- </TILES>

-- <SPRITES>
-- 000:000000000000005b000005bb00005bbb0005bbbb0055bbbb005bb55b0055bb5b
-- 001:00000000bbbbb0005bbb5b00bbbbbb0055555b00bbbbb000bbbb0000b05b0000
-- 002:0000000000000016000001660000166600016666001166660016611600116616
-- 003:0000000066666000166616006666660011111600666660006666000060160000
-- 004:0000000000000028000002880000288800028888002288880028822800228828
-- 005:0000000088888000288828008888880022222800888880008888000080280000
-- 006:000000000000004e000004ee00004eee0004eeee0044eeee004ee44e0044ee4e
-- 007:00000000eeeee0004eee4e00eeeeee0044444e00eeeee000eeee0000e04e0000
-- 008:000000000000003a000003aa00003aaa0003aaaa0033aaaa003aa33a0033aa3a
-- 009:00000000aaaaa0003aaa3a00aaaaaa0033333a00aaaaa000aaaa0000a03a0000
-- 010:00000000000000df00000dff0000dfff000dffff00ddffff00dffddf00ddffdf
-- 011:00000000fffff000dfffdf00ffffff00dddddf00fffff000ffff0000f0df0000
-- 016:0000005b000005bb00005bbb0005bbbb0005bbbb0005b5550055b00505bb0000
-- 017:bbbbb0005bbb5b00bbbbbb0055555b00bbbbb000b05b0000b05b000000000000
-- 018:0000001600000166000016660001666600016666000161110011600101660000
-- 019:6666600016661600666666001111160066666000601600006016000000000000
-- 020:0000002800000288000028880002888800028888000282220022800202880000
-- 021:8888800028882800888888002222280088888000802800008028000000000000
-- 022:0000004e000004ee00004eee0004eeee0004eeee0004e4440044e00404ee0000
-- 023:eeeee0004eee4e00eeeeee0044444e00eeeee000e04e0000e04e000000000000
-- 024:0000003a000003aa00003aaa0003aaaa0003aaaa0003a3330033a00303aa0000
-- 025:aaaaa0003aaa3a00aaaaaa0033333a00aaaaa000a03a0000a03a000000000000
-- 026:000000df00000dff0000dfff000dffff000dffff000dfddd00ddf00d0dff0000
-- 027:fffff000dfffdf00ffffff00dddddf00fffff000f0df0000f0df000000000000
-- 032:000000b000000bb00000bbb0000bbbb00000bbb000000bb0000000b000000000
-- 033:0b0000000bb000000bbb00000bbbb0000bbb00000bb000000b00000000000000
-- 034:0000006000000660000066600006666000006660000006600000006000000000
-- 035:0600000006600000066600000666600006660000066000000600000000000000
-- 036:0000008000000880000088800008888000008880000008800000008000000000
-- 037:0800000008800000088800000888800008880000088000000800000000000000
-- 038:000000e000000ee00000eee0000eeee00000eee000000ee0000000e000000000
-- 039:0e0000000ee000000eee00000eeee0000eee00000ee000000e00000000000000
-- 040:000000a000000aa00000aaa0000aaaa00000aaa000000aa0000000a000000000
-- 041:0a0000000aa000000aaa00000aaaa0000aaa00000aa000000a00000000000000
-- 042:000000f000000ff00000fff0000ffff00000fff000000ff0000000f000000000
-- 043:0f0000000ff000000fff00000ffff0000fff00000ff000000f00000000000000
-- 044:000000c000000cc00000ccc0000cccc00000ccc000000cc0000000c000000000
-- 045:0c0000000cc000000ccc00000cccc0000ccc00000cc000000c00000000000000
-- 048:0f0000f0f0f00f0ff0f00f0f0f0770f000777700000770000000000000000000
-- 049:0f0000f0f0f00f0ff0f00f0f0f0660f000666600000660000000000000000000
-- 050:0f0000f0f0f00f0ff0f00f0f0f0990f000999900000990000000000000000000
-- 051:0f0000f0f0f00f0ff0f00f0f0f0ee0f000eeee00000ee0000000000000000000
-- 052:0f0000f0f0f00f0ff0f00f0f0f0bb0f000bbbb00000bb0000000000000000000
-- 053:0f0000f0f0f00f0ff0f00f0f0f0dd0f000dddd00000dd0000000000000000000
-- </SPRITES>

-- <MAP>
-- 000:0d1d2d3d4d5d6d7d8d9dadbdcdddedfd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:0e1e2e3e4e5e6e7e8e9eaebecedeeefe0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:0f1f2f3f4f5f6f7f8f9fafbfcfdfefff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:213101110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:223202124252000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

-- <WAVES>
-- 000:135789abccddeeeeedddccbba9764210
-- 001:7bd9296686386bba7419a66387a62726
-- 002:04556776443333444554433333333344
-- </WAVES>

-- <SFX>
-- 000:c010b030a040a050906090709070908090809080a080a080b070c070d060e050f040f030f010f000f000f000f000f000f000f000f000f000f000f000370000000000
-- 001:01e701d601d511c5115421a021a321a2319f3182418e4171517051606160615f715f814e814d913da13cb13cb12cb12bc12bd11ad11ae109e108f108000000000000
-- </SFX>

