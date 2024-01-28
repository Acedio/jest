function ball_init()
  local state = {
    iswin=false,
    islose=false,

    balllist = {},
    health=3,
    time_limit=60,
    ball_limit=3; 
    center_x = 64,
    center_y = 90,
    line_length = 20,
    gravity = 0.1,
    bounce = -1,
    counter = 0,
    interval = 5 * 30 ,
    paddle_speed=2.5,

    turningleft=false,

    paddle_rotatespeed=0.002,
  
    score=0,

    angle=0,

    events = {
      {time=0, action="throw"},
      {time=1, action="throw"},
      {time=2, action="throw"},
      {time=8,  action="laugh"},
      {time=10,  action="throw"},
      {time=18,  action="laugh"},
      {time=20,  action="throw"},
    },

    distance
  }
  return state
  end

  function decideWhatToDo(state)
    foreach(state.events, function(event)
      if  state.counter==event.time*30 then 
          local action = event.action
          if action=="throw" then 
            throw(state)
            elseif action=="laugh" then
              kinglaugh(state)
          end
        end
      end)
  end

  function throw(state)
    local num= flr(rnd(3))
    if num!=1 then
      add(state.balllist, {ballx=1,bally=1,ballvx=1,ballvy=0,isegg=false})
    else
      add(state.balllist, {ballx=1,bally=1,ballvx=1,ballvy=0,isegg=true})
    end
  end


  function kinglaugh(state)

  end

  function ball_drop(state)
  end

  function win()
  end

  function lose(state)
  state.islose=true
  print("you lose",50,50,7)
  end
  




  function ball_update(state)
    decideWhatToDo(state) 
    state.counter+=1

    local ballstatelist={}
    local ballstateStr

    foreach(state.balllist, function(o)
        o.ballx,o.bally,o.ballvx,o.ballvy,ballstateStr
        =ball(o.ballx,o.bally,o.ballvx,o.ballvy,o,state)
        if ballstateStr!="nothing_happen" then 
          add(ballstatelist,ballstateStr)
        end

    end)

    foreach(ballstatelist, function(o)
      printh(o,"test.txt")
    end
    )

    if btn(0) then
        state.angle-=state.paddle_rotatespeed
        state.center_x -= state.paddle_speed
        state.turningleft=true
    elseif btn(1) then
      state.angle+=state.paddle_rotatespeed
      state.center_x += state.paddle_speed
      state.turningleft=false



    elseif btn(4) then
      state.angle+=state.paddle_rotatespeed
      elseif btn(5) then 
        state.angle-=state.paddle_rotatespeed	    
    end
    


  end

  function ball_draw(state)
    map()


    if state.health<0 then 
      lose(state)
    end


    draw_heart(state)
    foreach(state.balllist, function(o)
      if o.isegg==false then
        spr(44,o.ballx,o.bally,2,2)
      else 
        spr(40,o.ballx,o.bally,2,2)
      end
    end)

    local x1, y1, x2, y2 = update_line_endpoints(state)
    if state.turningleft==true then
    spr(12,state.center_x-8,state.center_y,2,2)
    else 
      spr(14,state.center_x-8,state.center_y,2,2)
    end

    line(x1, y1, x2, y2, 7)
    
  end


  function update_line_endpoints(state)
      local half_length = state.line_length / 2
      local end_x1 = state.center_x + cos(state.angle) * half_length
      local end_y1 = state.center_y + sin(state.angle) * half_length

      local end_x2 = state.center_x - cos(state.angle) * half_length
      local end_y2 = state.center_y - sin(state.angle) * half_length

      return end_x1, end_y1, end_x2, end_y2
  end

  function ball(x,y,vx,vy,ballstate,state)  
    local ballstateStr

    vy += state.gravity 
    y += vy     
        
    if x<1
    then
        x=1
        vx*=-1
    elseif x>100 then
        x=100   
        vx*=-1            
    end
        
        
        if y>90 and ballstate.isegg==false then 
          state.health-=1
          y=90
          vy*=-1

          ballstateStr="drop_ground"

        elseif y>90 and ballstate.isegg==true then
          del(state.balllist,ballstate)
          ballstateStr="badthings_drop_ground"


        end
        
        x+=vx
        count_distance(x,y,state)



    if state.distance <8
    and x >= min(state.center_x-state.line_length* cos(state.angle),state.center_x+state.line_length* cos(state.angle))-2
    and x <= max(state.center_x-state.line_length* cos(state.angle),state.center_x+state.line_length* cos(state.angle))-2
    then
    local distanceneed
    distanceneed=9-state.distance
        y -= distanceneed*cos(state.angle)
        x	-=	distanceneed*sin(state.angle)
      
      if ballstate.isegg==false then
        vx,vy=countcollision(vx,vy,state.angle)
        state.score+=1
        ballstateStr="collision"
      else 
        state.health-=1
        state.score-=5
        del(state.balllist,ballstate)
        ballstateStr="badthings_collision"
      end

    else
      ballstateStr="nothing_happen"    

    end
    
    return x,y,vx,vy,ballstateStr
    
  end

  function count_distance(x,y,state)    
    local m = sin(state.angle) / cos(state.angle)

    local d = abs(m * x - y + (state.center_y - m * state.center_x)) / sqrt(m^2 + 1)

    state.distance= d

  end


  function countcollision(vx,vy,angle)

		local vparalle=vx*cos(angle)+vy*sin(angle)
		local vperpendicular=-vx*sin(angle)+vy*cos(angle)
		vperpendicular*=-1

		vx=vparalle*cos(angle)-vperpendicular*sin(angle)
		vy=vparalle*sin(angle)+vperpendicular*cos(angle)
    return vx,vy

		end

    function draw_heart(state)
      for i=1,state.health do
    spr(73,85+i*8,10) 
    end
   end
