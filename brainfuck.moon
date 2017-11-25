-- title:   brainfuck interpreter
-- author:  Olivier Schyns
-- script:  moonscript
-- version: 0.3.1

BF="++++ ++++"..
"[>+++++ +++++<-]"..
">++++.----- ----- -.--- ---."--..
--uncomment to test error output
--"<< force a tape outbound"

IN=""

--tape to perform computation
class Tape
	
	new:(l,m)=>
		@l=l  --cell limit
		@m=m  --loop the finite tape
		@t={} --tape
		@h=0  --read head
		--correct values
		@l-=1 if @l~=nil
		@m-=1 if @m~=nil
	
	--rhead out of the bounds of the tape
	unbound:=>
		if @m~=nil then return @h>@m
		@h<0
	
	--init nil cell to zero
	init:=> @t[@h]=0 if @t[@h]==nil
	
	--move read head to the left
	mvL:=>
		@h-=1
		if @m~=nil then if @h<0
			@h=@m
	
	--move read head to the right
	mvR:=>
		@h+=1
		if @m~=nil then if @h>@m
			@h=0
	
	--decreament cell
	decr:=>
		@init!
		@t[@h]-=1
		if @l~=nil then if @t[@h]<0
			@t[@h]=@l
	
	--increament cell
	incr:=>
		@init!
		@t[@h]+=1
		if @l~=nil then if @t[@h]>@l
			@t[@h]=0
	
	--ins: insert value in cell
	--out: get value from cell
	
	ins:(i)=> @t[@h]=i if i~=nil
	out:   => @t[@h]   or 0

--stack to hold indexes of brackets
class Stack
	new:    => @s={}
	top:    => @s[#@s]
	pop:    => @s[#@s]=nil
	push:(i)=> @s[#@s+1]=i


--automaton to execute the program
class Automaton
	
	new:(p,i,l,m)=>
		@t=Tape l,m --tape
		@s=Stack!   --stack
		@r=1        --read head
		@p=""       --program
		@i=i        --input
		@o=""       --output
		@e=nil      --error
		--strip useless chars of program
		for c in p\gmatch "[<>%+%-%[%]%.%,]+"
			@p..=c
		b=@check!
		if b~=nil
			@e="brackets mismatch at "..b
	
	--check for brackets mismatch
	check:=>
		s=Stack!
		for i=1,#@p
			if     @program(i)=='[' then s\push i
			elseif @program(i)==']'
				return i    if #s.s<=0
				s\pop!
		return s\top! if #s.s> 0 
		return nil
	
	--get char from input
	input:=>
		if @i==nil or @i=="" then return nil
		c1=@i\byte! --1st char of i
		@i=@i\sub 2 --remove 1st char
		return c1
	
	--output:   add char to output
	--program:  get instruction at 'n'
	--continue: continue execution
	
	output: (n)=> @o..=string.char n
	program:(n)=> @p\sub n,n
	continu:   => @r<=#@p and @e==nil
	
	--find matching bracket
	match:(b)=>
		m=1
		while m>0 and b<=#@p
			b+=1
			if     @program(b)=='[' then m+=1
			elseif @program(b)==']' then m-=1
		return b
	
	--opening bracket
	open:=>
	 --jump to matching bracket
		if  (@t\out!)==0 then @r=@match @r
		else @s\push @r
		
	--closing bracket
	clos:=>
		if    (@t\out!)==0   then    @s\pop!
		elseif @s\top! ~=nil then @r=@s\top!
	
	--automaton's' execution step 
	step:=>
		switch @program @r
			when '<' then @t\mvL!
			when '>' then @t\mvR!
			when '-' then @t\decr!
			when '+' then @t\incr!
			when ',' then @t\ins  @input!
			when '.' then @output @t\out!
			when '[' then @open!
			when ']' then @clos!
		@r+=1
		if @t\unbound!
			@e="tape outbound !"


--display to see the execution
class Display
	
	new:(a,s=1,f=nil)=>
		@a=a    --automaton
		@s=s/60 --number of update per second
		@c=0    --counter
		@f=3    --display format of cells
		if     f=="hexadecimal" then @f=2
		elseif f=="character"   then @f=1
	
	--execute automaton all at once
	execute:=>
		while @a\continu!
			@a\step!
		@output!
	
	--update automaton at given frame rate
	update:=>
		if @a\continu!
			if @c<1 then @c+=@s
			else
				@c=0
				@a\step!
				@draw!
	
	--draw automaton state and output
	draw:=>
		cls!
		@tape    8, 2
		@program 8,12
		@output 4
		
	
	--draw the tape
	tape:(w=6,h=0,c=1,a=3)=>
		rect 0,h,240,w,c
		l=math.ceil (40/@f)*0.5
		p=(w-6)*0.5
		q=6*@f
		b=l-@a.t.h
		d=15
		if     @f==2 then d=6
		elseif @f==1 then d=3
		rect l*q-d,h,6*@f,w,a
		for i=@a.t.h-l,@a.t.h+l
			unless i<0
				c=15
				c=14 if i==@a.t.h
				v=@a.t.t[i] or 0
				if     @f==3 then v="%3d"\format v
				elseif @f==2 then v="%2x"\format v
				elseif @f==1 then v=string.char  v
				print v,(i+b)*q-d,h+p,c,true
	
	--draw the program
	program:(w=6,h=6,c=1,a=3)=>
		rect   0,h,240,w,c
		rect 117,h,  6,w,a
		p=(w-6)*0.5
		b=20-@a.r
		for i=@a.r-20,@a.r+20
			unless i<1
				c=15
				c=14 if i==@a.r
				v=@a\program i
				print v,(i+b)*6-3,h+p,c,true
	
	--print result of execution
	output:(s=0)=>
		i=s
		o=@a.o.."\n"
		--print each line
		for l in o\gmatch "[%S \t]*\n"
			print l,0,i*6,15,true
			i+=1
			break if i==21 --no more room
		--print error
		unless @a.e==nil
			print @a.e,0,130,6,true

--create automaton 'TM' using
--program : BF
--input   : IN
TM=Automaton BF,IN,128,nil

--create display 'DP' using
--automaton    : TM
--frame rate   : 30
--cell display : decimal
DP=Display TM,30,"decimal"

--execute the automaton and display it 
export TIC=->
	DP\update!

--http://moonscript.org/reference/
--http://moonscript.org/compiler/
--https://esolangs.org/wiki/Brainfuck
--http://zacstewart.com/2013/09/15/learning-cpp-a-brainfuck-interpreter.html

-- <PALETTE>
-- 000:140c1c44243430346d4e4a4e854c30346524d04648757161597dced27d2c8595a16daa2cd2aa996dc2cadad45edeeed6
-- </PALETTE>

-- <TILES>
-- 001:a000000aa0f00f0aaaaaaaaaaafaaa6aafffaaaaaafaa6aaaaaaaaaa33333333
-- 002:a000000aa060060aaaaaaaaaaafaaa6aafffaaaaaafaa6aaaaaaaaaa33333333
-- </TILES>

