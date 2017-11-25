-- title:  game title
-- author: game developer
-- desc:   short description
-- script: moon
-- input:  gamepad

add=(a,b)-> a+b
sub=(a,b)-> a-b

code=(a,b,fun)->
	if   a==32 then a=26
	else a-=97
	if   b==32 then b=26
	else b-=97
	c=fun(a,b)%27
	return   32 if c==26
	return c+97

cyph=(text,key,fun)->
	s=""
	j=1
	for i=1,#text
		a=string.byte text,i
		b=string.byte key ,j
		c=code a,b,fun
		s..=string.char c
		j+=1
		j%=#key+1
	return s

cypher  =(text,key)-> cyph text,key,add
decypher=(text,key)-> cyph text,key,sub

A="j aime la musique"
B="chat"
C=  cypher A,B
D=decypher C,B

cls!
print "text   : #{A}",0, 0,15,true
print "key    : #{B}",0, 6,15,true
print "cypher : #{C}",0,12,15,true
print "result : #{D}",0,18,15,true

export TIC=->
-- <PALETTE>
-- 000:140c1c44243430346d4e4a4e854c30346524d04648757161597dced27d2c8595a16daa2cd2aa996dc2cadad45edeeed6
-- </PALETTE>

-- <TILES>
-- 001:a000000aa0f00f0aaaaaaaaaaafaaa6aafffaaaaaafaa6aaaaaaaaaa33333333
-- 002:a000000aa060060aaaaaaaaaaafaaa6aafffaaaaaafaa6aaaaaaaaaa33333333
-- </TILES>

