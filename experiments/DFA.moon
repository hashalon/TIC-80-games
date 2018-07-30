-- title:  Deterministic Finite Automaton
-- author: Olivier Schyns
-- desc:   Execute a Turing Machine
-- script: moon
-- input:  gamepad
-- version 0.1.1

INPUT="1011"

--set of states
Q="a, b, c"

--alphabet
Z="0, 1"

--transition function
d="
 a,0 -> a |
 a,1 -> b |
 b,0 -> c |
 b,1 -> a |
 c,0 -> b |
 c,1 -> c |
"

--initial state
s="a"

--set of final states
F="c"

--functions to manage sets
add=(s,e)-> s[e]=true
rmv=(s,e)-> s[e]=nil

--regular expression that match
--letters numbers only
--\x2D -> '-'
regex="[^\x2D ,;:></\\|\n\t]+"

-- 5-tuple (Q,Z,d,s,F)
class Automaton
	
	--construct automaton
	new:(Q,Z,d,s,F)=>
		
		--set of states
		@Q={}
		add @Q,q for q in Q\gmatch regex
		
		--alphabet
		@Z={}
		add @Z,z for z in Z\gmatch regex
		
		--store transitions
		@d={}
		for r in d\gmatch '[^|;\n]+'
			t={}
			t[#t+1]=e for e in r\gmatch regex
			a,b,c=t[1],t[2],t[3]
			@chk_st  a
			@chk_sym b
			@chk_st  c
			--add rule
			@d["#{a},#{b}"]=c
		
		--start at initial state
		@q=s
		
		--store final sets in a set
		@F={}
		for f in F\gmatch regex
			add  @F,f
			@chk_st f
	
	
	--check state
	chk_st:(q)=>
		unless @Q[q]
			trace "state '#{q}' not defined !"
			return false
		return  true
	
	--check symbol
	chk_sym:(s)=>
		unless @Z[s]
			trace "symbol '#{s}' not defined !"
			return false
		return  true
	
	--feeds input
	input:(input)=>
		@i=input --input string
		@h=1     --read head
		@a=nil   --final answer
	
	getc:=> @i\sub @h,@h
	cont:=> @a==nil
	
	--execute one step
	step:=>
		--continue execution
		if @h<=#@i
			c=@getc!
			t=@d["#{@q},#{c}"]
			--if transition exist -> continue
			if t then @q=t
			--otherwise word not accepted
			else @a=false
			@h+=1 --next symbol
		
		--end of execution
		elseif @F[@q] then @a=true
		else @a=false
	
	--read input
	execute:(input)=>
		@input input
		while @cont!
			@step!
		return @a
	
	--display automaton transitions
	display:(y=0)=>
		print "transitions :",0,y,15,true
		for k,v in pairs @d
			y+=6
			print "#{k}->#{v}",0,y,15,true

A=Automaton Q,Z,d,s,F

cls!
ans=A\execute INPUT
dis=ans and "yes" or "no"
print "input  : #{INPUT}",0, 0,14,true
print "answer : #{dis}",  0, 6,14,true
A\display     18

export TIC=->
	

--transition rules
--{
-- a,0:a,
-- a,1:b,
-- b,0:c,
-- b,1:a,
-- c,0:b,
-- c,1:c
--}
-- <PALETTE>
-- 000:140c1c44243430346d4e4a4e854c30346524d04648757161597dced27d2c8595a16daa2cd2aa996dc2cadad45edeeed6
-- </PALETTE>

-- <TILES>
-- 001:a000000aa0f00f0aaaaaaaaaaafaaa6aafffaaaaaafaa6aaaaaaaaaa33333333
-- 002:a000000aa060060aaaaaaaaaaafaaa6aafffaaaaaafaa6aaaaaaaaaa33333333
-- </TILES>

