pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--j scherrer
--ims 213
--scherrjs@miamioh.edu

function _init()
	cls(0)
--values for determining what
--selection is occuring and
--who is selecting
	selecting=0
	who=1
	stopper=false
--what ship is selected
	cursor_on=1
--shooting direction
	shoot=1
--hit checker
	unhit=true
--scoring
	bscore=0
	rscore=0
--gamestate
	state=0
--animation counter
	end_count=0
--creating array and values
--for laser positions
	laser_x={}
	laser_y={}
	laser_count=0
	shooting=false
--blue ship positions and
--existence
	bship_x={8,40,72,104}
	bship_y={120,120,120,120}
	bship_e={true,true,true,true}
	bship_f={1,1,1,1}
--selector position
	selector_x=-8
	selector_y=-8
	selector_e=false
--red ship positions and showing
	rship_x={8,40,72,104}
	rship_y={0,0,0,0}
	rship_e={true,true,true,true}
	rship_f={2,2,2,2}
--meteor positions and showing
	meteor_x={}
	meteor_y={}
	meteor_e={}
--explosion position and showing
	explosion_x=-8
	explosion_y=-8
	explo_count=0
	explo=false
--initialize the meteor
--positions
	for row=5,10  do
	 for col=0,15 do
	  local y=row*8
	  local x=col*8
	  add(meteor_y,y)
	  add(meteor_x,x)
	  add(meteor_e,true)
	 end
	end
--start music
	music(0)
end
-->8
function _update()
 if state==0 then
--game start checker on start
--menu
  if btnp(5) then
   music(-1)
   music(1)
   state=1
  end
--main game state
 elseif state==1 then
--blue player's turn
	 if who==1 then
--which ship the cursor starts
--on
	  if selecting==0 then
	   selector_e=true
	   for i=1,4 do
	    if bship_e[i] and stopper==false then
	     selector_x=bship_x[i]
	     selector_y=bship_y[i]
	     stopper=true
	     selecting=1
	     cursor_on=i
	    end
	   end
--player selects which ship
	  elseif selecting==1 then
	   bshipselector()
--player selects where ship
--moves to or rotates
	  elseif selecting==2 then
	   bshipmovement()
--select which direction to
--shoot in
	  elseif selecting==3 then
	   bshipfire()
	  elseif selecting==4 then
--create the lasers/explosion
	   selector_e=false
	   for i=1,3 do
	    bshoot(i)
--reset and switch to red's
--turn
	   end
	   laser_count=0
	   shooting=true
	   who=2
	   selecting=0
	   stopper=false
	   unhit=true
	  end
	 else
--do the same stuff but for
--red ships
	  if selecting==0 then
	   selector_e=true
	   for i=1,4 do
	    if rship_e[i] and stopper==false then
	     selector_x=rship_x[i]
	     selector_y=rship_y[i]
	     stopper=true
	     selecting=1
	     cursor_on=i
	    end
	   end
	  elseif selecting==1 then
	   rshipselector()
	  elseif selecting==2 then
	   rshipmovement()
	  elseif selecting==3 then
	   rshipfire()
	  elseif selecting==4 then
	   selector_e=false
	   for i=1,3 do
	    rshoot(i)
	   end
	   laser_count=0
	   shooting=true
	   who=1
	   selecting=0
	   stopper=false
	   unhit=true
	  end
	 end
--if someone destroys all other
--ships, play out laser anim
--and then end game
	 if bscore==4 or rscore==4 then
	  if end_count<15 then
	   end_count+=1
	  else
	   music(-1)
	   sfx(6)
	   state=2
	  end
	 end
	elseif state==2 then
--reset values if played again,
--like _init()
	 if btnp(5) then
	  selecting=0
	  who=1
	  stopper=false
	  cursor_on=1
	  shoot=1
	  unhit=true
	  bscore=0
	  rscore=0
	  state=1
	  end_count=0
	
	  laser_x={}
	  laser_y={}
	  laser_count=0
	  shooting=false
	
	  bship_x={8,40,72,104}
	  bship_y={120,120,120,120}
	  bship_e={true,true,true,true}
	  bship_f={1,1,1,1}
	
	  selector_x=-8
	  selector_y=-8
	  selector_e=false
	
  	rship_x={8,40,72,104}
	  rship_y={0,0,0,0}
	  rship_e={true,true,true,true}
	  rship_f={2,2,2,2}
	
  	meteor_x={}
	  meteor_y={}
	  meteor_e={}
	
  	explosion_x=-8
	  explosion_y=-8
	  explo_count=0
	  explo=false
	
  	for row=5,10  do
	   for col=0,15 do
	    local y=row*8
	    local x=col*8
	    add(meteor_y,y)
	    add(meteor_x,x)
	    add(meteor_e,true)
	   end
  	end
  	music(1)
  end
 end
end
-->8
function _draw()
--draw start menu
 if state==0 then
  cls(1)
  print("battle blast!",38,28)
  print("use arrow keys to move the",12,40,6)
  print("cursor, press z to select.",12,48,6)
  print("press x to rotate your ship",10,56,6)
  print("during movement selection.",12,64,6)
  print("first to destroy all enemy",12,72,6)
  print("ships is the winner!",24,80,6)
  print("press ??? to start",30,100,6)
 elseif state==1 then
  cls(0)
--draw meteors
	 for m=1,96 do
	  if meteor_e[m] then
	   spr(6,meteor_x[m],meteor_y[m])
	  end
	 end
--draw blue ships
	 for b=1,4 do
	  if bship_e[b] then
--draw based on facing
	   if bship_f[b]==1 then
	    spr(1,bship_x[b],bship_y[b])
	   else
	    spr(1,bship_x[b],bship_y[b],1,1,false,true)
	   end
	  end
	 end
--draw red ships
	 for r=1,4 do
	  if rship_e[r] then
	   if rship_f[r]==2 then
	    spr(2,rship_x[r],rship_y[r])
	   else
	    spr(2,rship_x[r],rship_y[r],1,1,false,true)
	   end
	  end
	 end
--draw lasers for a period of
--time
	 if shooting==true and laser_count<15 then
	  for s=1,#laser_x do
	   if shoot==1 then
	    spr(4,laser_x[s],laser_y[s])
	   else
	    spr(3,laser_x[s],laser_y[s])
	   end
	  end
	  laser_count+=1
--when done, delete laser array
--contents to reset values
	 elseif shooting==true and laser_count==15 then
	  local limit=#laser_x
	  for i=1,limit do
	   deli(laser_x,1)
	   deli(laser_y,1)
	  end
	  shooting=false
	  laser_count=0
	 end
--play explosion for period of
--time
	 if explo==true and  explo_count<15 then
	  spr(5,explosion_x,explosion_y)
	  explo_count+=1
	 elseif explo==true and explo_count==15 then
	  explosion_x=-8
	  explosion_y=-8
	  explo=false
	  explo_count=0
	 end
--draw selector if on screen
	 if selector_e then
	  spr(7,selector_x,selector_y)
	 end
--draw end screen, say who won
--and display the score
	elseif state==2 then
	 cls(5)
	 if rscore>bscore then
	  print("red wins!",46,40,8)
	  print(rscore.." to "..bscore,52,48,8)
	  print("press ??? to play again",20,70,8)
	 else
	  print("blue wins!",44,40,12)
	  print(bscore.." to "..rscore,52,48,12)
	  print("press ??? to play again",20,70,12)
	 end
	end
end
-->8
function bshipselector()
--moves between ships to select
--based on which ones exist
--and which one is currently
--selected
 if btnp(0) then
  if cursor_on==4 then
   if bship_e[3] then
    cursor_on=3
    selector_x=bship_x[3]
    selector_y=bship_y[3]
   elseif bship_e[2] then
    cursor_on=2
    selector_x=bship_x[2]
    selector_y=bship_y[2]
   elseif bship_e[1] then
    cursor_on=1
    selector_x=bship_x[1]
    selector_y=bship_y[1]
   end
  elseif cursor_on==3 then
   if bship_e[2] then
    cursor_on=2
    selector_x=bship_x[2]
    selector_y=bship_y[2]
   elseif bship_e[1] then
    cursor_on=1
    selector_x=bship_x[1]
    selector_y=bship_y[1]
   end
  elseif cursor_on==2 then
   if bship_e[1] then
    cursor_on=1
    selector_x=bship_x[1]
    selector_y=bship_y[1]
   end
  end
 elseif btnp(1) then
  if cursor_on==1 then
   if bship_e[2] then
    cursor_on=2
    selector_x=bship_x[2]
    selector_y=bship_y[2]
   elseif bship_e[3] then
    cursor_on=3
    selector_x=bship_x[3]
    selector_y=bship_y[3]
   elseif bship_e[4] then
    cursor_on=4
    selector_x=bship_x[4]
    selector_y=bship_y[4]
   end
  elseif cursor_on==2 then
   if bship_e[3] then
    cursor_on=3
    selector_x=bship_x[3]
    selector_y=bship_y[3]
   elseif bship_e[4] then
    cursor_on=4
    selector_x=bship_x[4]
    selector_y=bship_y[4]
   end
  elseif cursor_on==3 then
   if bship_e[4] then
    cursor_on=4
    selector_x=bship_x[4]
    selector_y=bship_y[4]
   end
  end
--input selection
 elseif btnp(4) then
  sfx(5)
  selecting=2
 end
end

function rshipselector()
--same for red ships
 if btnp(0) then
  if cursor_on==4 then
   if rship_e[3] then
    cursor_on=3
    selector_x=rship_x[3]
    selector_y=rship_y[3]
   elseif rship_e[2] then
    cursor_on=2
    selector_x=rship_x[2]
    selector_y=rship_y[2]
   elseif rship_e[1] then
    cursor_on=1
    selector_x=rship_x[1]
    selector_y=rship_y[1]
   end
  elseif cursor_on==3 then
   if rship_e[2] then
    cursor_on=2
    selector_x=rship_x[2]
    selector_y=rship_y[2]
   elseif rship_e[1] then
    cursor_on=1
    selector_x=rship_x[1]
    selector_y=rship_y[1]
   end
  elseif cursor_on==2 then
   if rship_e[1] then
    cursor_on=1
    selector_x=rship_x[1]
    selector_y=rship_y[1]
   end
  end
 elseif btnp(1) then
  if cursor_on==1 then
   if rship_e[2] then
    cursor_on=2
    selector_x=rship_x[2]
    selector_y=rship_y[2]
   elseif rship_e[3] then
    cursor_on=3
    selector_x=rship_x[3]
    selector_y=rship_y[3]
   elseif rship_e[4] then
    cursor_on=4
    selector_x=rship_x[4]
    selector_y=rship_y[4]
   end
  elseif cursor_on==2 then
   if rship_e[3] then
    cursor_on=3
    selector_x=rship_x[3]
    selector_y=rship_y[3]
   elseif rship_e[4] then
    cursor_on=4
    selector_x=rship_x[4]
    selector_y=rship_y[4]
   end
  elseif cursor_on==3 then
   if rship_e[4] then
    cursor_on=4
    selector_x=rship_x[4]
    selector_y=rship_y[4]
   end
  end
 elseif btnp(4) then
  sfx(5)
  selecting=2
 end
end
-->8
function bshipmovement()
	if btnp(0) then
--select to the left if it can
	 if bship_x[cursor_on]!=0 and bcoll(0) then
	  selector_x=bship_x[cursor_on]-8
	  selector_y=bship_y[cursor_on]
	 end
	elseif btnp(1) then
--select to the right if it can
	 if bship_x[cursor_on]!=120 and bcoll(1) then
	  selector_x=bship_x[cursor_on]+8
	  selector_y=bship_y[cursor_on]
	 end
	elseif btnp(2) then
--select up if it can
	 if bship_y[cursor_on]!=0 and bcoll(2) then
	  selector_x=bship_x[cursor_on]
	  selector_y=bship_y[cursor_on]-8
	 end
	elseif btnp(3) then
--select down if it can
	 if bship_y[cursor_on]!=120 and bcoll(3) then
	  selector_x=bship_x[cursor_on]
	  selector_y=bship_y[cursor_on]+8
	 end
	elseif btnp(5) then
--rotate
	 if bship_f[cursor_on]==1 then
	  bship_f[cursor_on]=2
	 else
	  bship_f[cursor_on]=1
	 end
	 sfx(5)
	 selecting=3
	elseif btnp(4) then
--input movement selection
	 bship_x[cursor_on]=selector_x
	 bship_y[cursor_on]=selector_y
	 if bship_f[cursor_on]==1 then
	  selector_x=bship_x[cursor_on]-8
	  selector_y=bship_y[cursor_on]-8
	  shoot=1
	 else
	  selector_x=bship_x[cursor_on]+8
	  selector_y=bship_y[cursor_on]+8
	  shoot=1
	 end
	 sfx(5)
	 selecting=3 
	end
end

function rshipmovement()
--same for red ships
	if btnp(0) then
	 if rship_x[cursor_on]!=0 and rcoll(0) then
	  selector_x=rship_x[cursor_on]-8
	  selector_y=rship_y[cursor_on]
	 end
	elseif btnp(1) then
	 if rship_x[cursor_on]!=120 and rcoll(1) then
	  selector_x=rship_x[cursor_on]+8
	  selector_y=rship_y[cursor_on]
	 end
	elseif btnp(2) then
	 if rship_y[cursor_on]!=0 and rcoll(2) then
	  selector_x=rship_x[cursor_on]
	  selector_y=rship_y[cursor_on]-8
	 end
	elseif btnp(3) then
	 if rship_y[cursor_on]!=120 and rcoll(3) then
	  selector_x=rship_x[cursor_on]
	  selector_y=rship_y[cursor_on]+8
	 end
	elseif btnp(5) then
	 if rship_f[cursor_on]==1 then
	  rship_f[cursor_on]=2
	 else
	  rship_f[cursor_on]=1
	 end
	 sfx(5)
	 selecting=3
	elseif btnp(4) then
	 rship_x[cursor_on]=selector_x
	 rship_y[cursor_on]=selector_y
	 if rship_f[cursor_on]==1 then
	  selector_x=rship_x[cursor_on]-8
	  selector_y=rship_y[cursor_on]-8
	  shoot=1
	 else
	  selector_x=rship_x[cursor_on]+8
	  selector_y=rship_y[cursor_on]+8
	  shoot=1
	 end
	 sfx(5)
	 selecting=3
	end
end
-->8
function bshipfire()
--which way to shoot laser
 if bship_f[cursor_on]==1 then
--shoots up if facing up
	 if btnp(0) then
--move between directions
	  selector_x=bship_x[cursor_on]-8
	  selector_y=bship_y[cursor_on]-8
	  shoot=1
	 elseif btnp(1) then
	  selector_x=bship_x[cursor_on]+8
	  selector_y=bship_y[cursor_on]-8
	  shoot=2
	 elseif btnp(4) then
--input selection
	  selecting=4
	  sfx(3)
	 end
	else
--same but below if facing down
	 if btnp(1) then
	  selector_x=bship_x[cursor_on]+8
	  selector_y=bship_y[cursor_on]+8
	  shoot=1
	 elseif btnp(0) then
	  selector_x=bship_x[cursor_on]-8
	  selector_y=bship_y[cursor_on]+8
	  shoot=2
	 elseif btnp(4) then
	  selecting=4
	  sfx(3)
	 end
	end
end

function bshoot(step)
--checks collision of lasers
--and other objects
 if bship_f[cursor_on]==1 then
  if shoot==1 then
--check meteors when shooting
--in specific direction
   for m=1,96 do
    if unhit and meteor_e[m] and collide(bship_x[cursor_on]-(step*8),
    bship_y[cursor_on]-(step*8),8,8,
    meteor_x[m],meteor_y[m],8,8) then
     unhit=false
     meteor_e[m]=false
     explosion_x=meteor_x[m]
     explosion_y=meteor_y[m]
     explo=true
     explo_count=0
     sfx(4)
    end
   end
--check ship collisions
   for s=1,4 do
    if unhit and rship_e[s] and
    collide(bship_x[cursor_on]-(step*8),
    bship_y[cursor_on]-(step*8),8,8,
    rship_x[s],rship_y[s],8,8) then
     unhit=false
     rship_e[s]=false
     explosion_x=rship_x[s]
     explosion_y=rship_y[s]
     explo=true
     explo_count=0
     bscore+=1
     sfx(4)
    end
   end
--create laser if nothing is hit
   if unhit and explo==false then
    add(laser_x,(bship_x[cursor_on]-(step*8)))
    add(laser_y,(bship_y[cursor_on]-(step*8)))
   end
  else
--check second shooting direction
--and do checks there
   for m=1,96 do
    if unhit and meteor_e[m] and collide(bship_x[cursor_on]+(step*8),
    bship_y[cursor_on]-(step*8),8,8,
    meteor_x[m],meteor_y[m],8,8) then
     unhit=false
     meteor_e[m]=false
     explosion_x=meteor_x[m]
     explosion_y=meteor_y[m]
     explo=true
     explo_count=0
     sfx(4)
    end
   end
   for s=1,4 do
    if unhit and rship_e[s] and
    collide(bship_x[cursor_on]+(step*8),
    bship_y[cursor_on]-(step*8),8,8,
    rship_x[s],rship_y[s],8,8) then
     unhit=false
     rship_e[s]=false
     explosion_x=rship_x[s]
     explosion_y=rship_y[s]
     explo=true
     explo_count=0
     bscore+=1
     sfx(4)
    end
   end
   if unhit and explo==false then
    add(laser_x,(bship_x[cursor_on]+(step*8)))
    add(laser_y,(bship_y[cursor_on]-(step*8)))
   end
  end
 else
--check third direction and do
--collision checks there
  if shoot==1 then
   for m=1,96 do
    if unhit and meteor_e[m] and collide(bship_x[cursor_on]+(step*8),
    bship_y[cursor_on]+(step*8),8,8,
    meteor_x[m],meteor_y[m],8,8) then
     unhit=false
     meteor_e[m]=false
     explosion_x=meteor_x[m]
     explosion_y=meteor_y[m]
     explo=true
     explo_count=0
     sfx(4)
    end
   end
   for s=1,4 do
    if unhit and rship_e[s] and
    collide(bship_x[cursor_on]+(step*8),
    bship_y[cursor_on]+(step*8),8,8,
    rship_x[s],rship_y[s],8,8) then
     unhit=false
     rship_e[s]=false
     explosion_x=rship_x[s]
     explosion_y=rship_y[s]
     explo=true
     explo_count=0
     bscore+=1
     sfx(4)
    end
   end
   if unhit and explo==false then
    add(laser_x,(bship_x[cursor_on]+(step*8)))
    add(laser_y,(bship_y[cursor_on]+(step*8)))
   end
  else
--check fourth direction and do
--collision checks there
   for m=1,96 do
    if unhit and meteor_e[m] and collide(bship_x[cursor_on]-(step*8),
    bship_y[cursor_on]+(step*8),8,8,
    meteor_x[m],meteor_y[m],8,8) then
     unhit=false
     meteor_e[m]=false
     explosion_x=meteor_x[m]
     explosion_y=meteor_y[m]
     explo=true
     explo_count=0
     sfx(4)
    end
   end
   for s=1,4 do
    if unhit and rship_e[s] and
    collide(bship_x[cursor_on]-(step*8),
    bship_y[cursor_on]+(step*8),8,8,
    rship_x[s],rship_y[s],8,8) then
     unhit=false
     rship_e[s]=false
     explosion_x=rship_x[s]
     explosion_y=rship_y[s]
     explo=true
     explo_count=0
     bscore+=1
     sfx(4)
    end
   end
   if unhit and explo==false then
    add(laser_x,(bship_x[cursor_on]-(step*8)))
    add(laser_y,(bship_y[cursor_on]+(step*8)))
   end
  end
 end
end

function rshipfire()
--repeat firing selection for
--red ships
 if rship_f[cursor_on]==1 then
	 if btnp(0) then
	  selector_x=rship_x[cursor_on]-8
	  selector_y=rship_y[cursor_on]-8
	  shoot=1
	 elseif btnp(1) then
	  selector_x=rship_x[cursor_on]+8
	  selector_y=rship_y[cursor_on]-8
	  shoot=2
	 elseif btnp(4) then
	  selecting=4
	  sfx(3)
	 end
	else
	 if btnp(1) then
	  selector_x=rship_x[cursor_on]+8
	  selector_y=rship_y[cursor_on]+8
	  shoot=1
	 elseif btnp(0) then
	  selector_x=rship_x[cursor_on]-8
	  selector_y=rship_y[cursor_on]+8
	  shoot=2
	 elseif btnp(4) then
	  selecting=4
	  sfx(3)
	 end
	end
end

function rshoot(step)
--laser and explosion checks
--for red ships
 if rship_f[cursor_on]==1 then
  if shoot==1 then
   for m=1,96 do
    if unhit and meteor_e[m] and collide(rship_x[cursor_on]-(step*8),
    rship_y[cursor_on]-(step*8),8,8,
    meteor_x[m],meteor_y[m],8,8) then
     unhit=false
     meteor_e[m]=false
     explosion_x=meteor_x[m]
     explosion_y=meteor_y[m]
     explo=true
     explo_count=0
     sfx(4)
    end
   end
   for s=1,4 do
    if unhit and bship_e[s] and
    collide(rship_x[cursor_on]-(step*8),
    rship_y[cursor_on]-(step*8),8,8,
    bship_x[s],bship_y[s],8,8) then
     unhit=false
     bship_e[s]=false
     explosion_x=bship_x[s]
     explosion_y=bship_y[s]
     explo=true
     explo_count=0
     rscore+=1
     sfx(4)
    end
   end
   if unhit and explo==false then
    add(laser_x,(rship_x[cursor_on]-(step*8)))
    add(laser_y,(rship_y[cursor_on]-(step*8)))
   end
  else
   for m=1,96 do
    if unhit and meteor_e[m] and collide(rship_x[cursor_on]+(step*8),
    rship_y[cursor_on]-(step*8),8,8,
    meteor_x[m],meteor_y[m],8,8) then
     unhit=false
     meteor_e[m]=false
     explosion_x=meteor_x[m]
     explosion_y=meteor_y[m]
     explo=true
     explo_count=0
     sfx(4)
    end
   end
   for s=1,4 do
    if unhit and bship_e[s] and
    collide(rship_x[cursor_on]+(step*8),
    rship_y[cursor_on]-(step*8),8,8,
    bship_x[s],bship_y[s],8,8) then
     unhit=false
     bship_e[s]=false
     explosion_x=bship_x[s]
     explosion_y=bship_y[s]
     explo=true
     explo_count=0
     rscore+=1
     sfx(4)
    end
   end
   if unhit and explo==false then
    add(laser_x,(rship_x[cursor_on]+(step*8)))
    add(laser_y,(rship_y[cursor_on]-(step*8)))
   end
  end
 else
  if shoot==1 then
   for m=1,96 do
    if unhit and meteor_e[m] and collide(rship_x[cursor_on]+(step*8),
    rship_y[cursor_on]+(step*8),8,8,
    meteor_x[m],meteor_y[m],8,8) then
     unhit=false
     meteor_e[m]=false
     explosion_x=meteor_x[m]
     explosion_y=meteor_y[m]
     explo=true
     explo_count=0
     sfx(4)
    end
   end
   for s=1,4 do
    if unhit and bship_e[s] and
    collide(rship_x[cursor_on]+(step*8),
    rship_y[cursor_on]+(step*8),8,8,
    bship_x[s],bship_y[s],8,8) then
     unhit=false
     bship_e[s]=false
     explosion_x=bship_x[s]
     explosion_y=bship_y[s]
     explo=true
     explo_count=0
     rscore+=1
     sfx(4)
    end
   end
   if unhit and explo==false then
    add(laser_x,(rship_x[cursor_on]+(step*8)))
    add(laser_y,(rship_y[cursor_on]+(step*8)))
   end
  else
   for m=1,96 do
    if unhit and meteor_e[m] and collide(rship_x[cursor_on]-(step*8),
    rship_y[cursor_on]+(step*8),8,8,
    meteor_x[m],meteor_y[m],8,8) then
     unhit=false
     meteor_e[m]=false
     explosion_x=meteor_x[m]
     explosion_y=meteor_y[m]
     explo=true
     explo_count=0
     sfx(4)
    end
   end
   for s=1,4 do
    if unhit and bship_e[s] and
    collide(rship_x[cursor_on]-(step*8),
    rship_y[cursor_on]+(step*8),8,8,
    bship_x[s],bship_y[s],8,8) then
     unhit=false
     bship_e[s]=false
     explosion_x=bship_x[s]
     explosion_y=bship_y[s]
     explo=true
     explo_count=0
     rscore+=1
     sfx(4)
    end
   end
   if unhit and explo==false then
    add(laser_x,(rship_x[cursor_on]-(step*8)))
    add(laser_y,(rship_y[cursor_on]+(step*8)))
   end
  end
 end
end
-->8
function collide(
 x1,y1,
 w1,h1,
 x2,y2,
 w2,h2)
 
--collision function - checks
--if the distance between
--center of object bounding
--boxes is less than their
--half-widths and half-heights
--combined
 local xd=abs((x1+(w1/2))-(x2+(w2/2)))
 local xs=w1*0.5+w2*0.5
 local yd=abs((y1+(h1/2))-(y2+(h2/2)))
 local ys=h1/2+h2/2
--if the objects collide,
--return true
 if xd<xs and yd<ys then 
  return true 
 else
  return false
 end
end

function bcoll(bt)
--checks for collisions to the
--left to make sure movements 
--are clear
	local check=true
	if bt==0 then
	 for m=1,96 do
	  if collide((bship_x[cursor_on]-8),
	  bship_y[cursor_on],8,8,
	  meteor_x[m],meteor_y[m],8,8)
	  and meteor_e[m] then
	   check=false
	  end
	 end
	 for s=1,4 do
	  if rship_e[s] and
   collide(bship_x[cursor_on]-8,
   bship_y[cursor_on],8,8,
   rship_x[s],rship_y[s],8,8) then
    check=false
   end
  end
 elseif bt==1 then
--same checks to the right
  for m=1,96 do
	  if collide((bship_x[cursor_on]+8),
	  bship_y[cursor_on],8,8,
	  meteor_x[m],meteor_y[m],8,8)
	  and meteor_e[m] then
	   check=false
	  end
	 end
	 for s=1,4 do
	  if rship_e[s] and
   collide(bship_x[cursor_on]+8,
   bship_y[cursor_on],8,8,
   rship_x[s],rship_y[s],8,8) then
    check=false
   end
  end
 elseif bt==2 then
--same checks up
  for m=1,96 do
	  if collide((bship_x[cursor_on]),
	  bship_y[cursor_on]-8,8,8,
	  meteor_x[m],meteor_y[m],8,8)
	  and meteor_e[m] then
	   check=false
	  end
	 end
	 for s=1,4 do
	  if rship_e[s] and
   collide(bship_x[cursor_on],
   bship_y[cursor_on]-8,8,8,
   rship_x[s],rship_y[s],8,8) then
    check=false
   end
  end
 elseif bt==3 then
--same checks down
  for m=1,96 do
	  if collide((bship_x[cursor_on]),
	  bship_y[cursor_on]+8,8,8,
	  meteor_x[m],meteor_y[m],8,8)
	  and meteor_e[m] then
	   check=false
	  end
	 end
	 for s=1,4 do
	  if rship_e[s] and
   collide(bship_x[cursor_on],
   bship_y[cursor_on]+8,8,8,
   rship_x[s],rship_y[s],8,8) then
    check=false
   end
  end
 else
  return true
 end
--if cleared, return true,
--else, false
 if check then
  return true
 else
  return false
 end
end

function rcoll(bt)
--same directional movement
--checks for red ships
	local check=true
	if bt==0 then
	 for m=1,96 do
	  if collide((rship_x[cursor_on]-8),
	  rship_y[cursor_on],8,8,
	  meteor_x[m],meteor_y[m],8,8)
	  and meteor_e[m] then
	   check=false
	  end
	 end
	 for s=1,4 do
	  if bship_e[s] and
   collide(rship_x[cursor_on]-8,
   rship_y[cursor_on],8,8,
   bship_x[s],bship_y[s],8,8) then
    check=false
   end
  end
 elseif bt==1 then
  for m=1,96 do
	  if collide((rship_x[cursor_on]+8),
	  rship_y[cursor_on],8,8,
	  meteor_x[m],meteor_y[m],8,8)
	  and meteor_e[m] then
	   check=false
	  end
	 end
	 for s=1,4 do
	  if bship_e[s] and
   collide(rship_x[cursor_on]+8,
   rship_y[cursor_on],8,8,
   bship_x[s],bship_y[s],8,8) then
    check=false
   end
  end
 elseif bt==2 then
  for m=1,96 do
	  if collide((rship_x[cursor_on]),
	  rship_y[cursor_on]-8,8,8,
	  meteor_x[m],meteor_y[m],8,8)
	  and meteor_e[m] then
	   check=false
	  end
	 end
	 for s=1,4 do
	  if bship_e[s] and
   collide(rship_x[cursor_on],
   rship_y[cursor_on]-8,8,8,
   bship_x[s],bship_y[s],8,8) then
    check=false
   end
  end
 elseif bt==3 then
  for m=1,96 do
	  if collide((rship_x[cursor_on]),
	  rship_y[cursor_on]+8,8,8,
	  meteor_x[m],meteor_y[m],8,8)
	  and meteor_e[m] then
	   check=false
	  end
	 end
	 for s=1,4 do
	  if bship_e[s] and
   collide(rship_x[cursor_on],
   rship_y[cursor_on]+8,8,8,
   bship_x[s],bship_y[s],8,8) then
    check=false
   end
  end
 else
  return true
 end
 if check then
  return true
 else
  return false
 end
end
__gfx__
00000000000cc000800000080000003bb3000000000aa0aa00000000aaaaaaaa0000000000000000000000000000000000000000000000000000000000000000
00000000b0c66c0b88000088000003b33b3000000a9aaa0005d50050a000000a0000000000000000000000000000000000000000000000000000000000000000
007007000bccccb08888888800003b3003b30000aaa999aa5d55d5d0a000000a0000000000000000000000000000000000000000000000000000000000000000
000770000cbccbc0088888800003b300003b30000a9889a055555555a000000a0000000000000000000000000000000000000000000000000000000000000000
000770000cccccc008b88b80003b30000003b3000a9899a055d555d5a000000a0000000000000000000000000000000000000000000000000000000000000000
00700700cccccccc0b8888b003b3000000003b300aa9aaa0d555d55da000000a0000000000000000000000000000000000000000000000000000000000000000
00000000cc0000ccb086680b3b300000000003b300a000a00d5555d0a000000a0000000000000000000000000000000000000000000000000000000000000000
00000000c000000c00088000b30000000000003ba000a00000055500aaaaaaaa0000000000000000000000000000000000000000000000000000000000000000
__sfx__
011200001a0501b0501a0501b0501a0501b0501a0501b0501a050000001a050000001a050000001b0501a0500000019050180501705000000160501505014050130501405015050160501705018050190501a050
011200000c0500c0500c0500d0500e0500e05000000000000c0500c0500c0500d0500e0500e0500000000000100501005000000000000f0500f05000000000000b0500b0500b000000000d0500d0500000000000
011200000c6150c60500000000000c6150c60500000000000c6150c60500000000000c6150c60500000000000c6150c61500000000000c6150c60500000000000c6150c61500000000000c6150c6050000000000
010300003575234752327523075200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011e00001865300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010800003015400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000002405024050240002405000000000002805028050290502905029050290500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
03 00424344
03 01024344

