function ball_init()
  local time_limit = 40
  local state = {
    iswin=false,
    islose=false,

    anglelimit={-0.08,0.08},
    spacelimit={12,115},
    balllist = {},
    health=3,
    ball_limit=3; 
    time_limit=time_limit,
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
    anglelimit={-0.08,0.08},
  
    score=0,

    angle=0,

    events = {
      {time=0, action="laugh"},
      {time=1, action="throw"},
      {time=3, action="laugh"},
      {time=4, action="throw"},
      {time=8,  action="laugh"},
      {time=9,  action="throw"},
      {time=19,  action="laugh"},
      {time=20,  action="throw"},
      {time=time_limit, action="win"},
    },

    object_types = {
      {good=true},
      {good=true},
      {good=true},
      {good=false},
      {good=false},
      {good=true},
      {good=true},
      {good=true},
    },

    audience_state=audience_init(),
    king_state=king_init(),

    distance
  }
  music(1)
  return state
  end

  function king_init()
    return {
      t = 0,
      laugh_t = 127,
      x = 64-8,
      y = 32,
    }
  end

  function king_laugh(s)
    sfx(0)
    s.laugh_t = 0
  end

  function king_update(s)
    s.t += 1
    if s.laugh_t < 127 then
      s.laugh_t += 1
    end
  end

  function king_draw(s)
    palt(0x0010)
    if s.laugh_t > 6 and s.laugh_t < 32 then
      if band(s.t, 2) == 0 then
        spr(6, s.x, s.y, 2, 2)
      else
        spr(0, s.x, s.y, 2, 2)
      end
    elseif band(s.t\15,1) == 1 then
      spr(0, s.x, s.y, 2, 2)
    else
      spr(2, s.x, s.y, 2, 2)
    end
  end

  function audience_init()
    return {
      t = 0,
    }
  end

  function audience_update(s)
    s.t += 1
  end

  function audience_draw(s)
    --audience
    palt(0x0080)
    for i=0,7 do
      spr(104+2*(i%4),i*16,112+3+3*sin((s.t+10*i)/50),2,2)
    end
    --curtains
    for i=0,2 do
      spr(96,16+32*i,0,4,2)
    end
  end

  function decideWhatToDo(state)
    for i=1,#state.events do
      if  state.counter==state.events[i].time*30 then 
          local action = state.events[i].action
          if action=="throw" then 
            throw(state)
          elseif action=="laugh" then
            king_laugh(state.king_state)
          elseif action=="win" then
            state.iswin = true
          end
        end
      end
  end

  function throw(state)
    local object = flr(rnd(8)) + 1
		add(state.balllist, {ballx=1,bally=1,ballvx=1,ballvy=0,object_type=object})
  end

 function inanglelimit(state)
    if state.angle>state.anglelimit[1] and state.angle<state.anglelimit[2] then
      return true
    else
      return false
    end
  end
  function inspace(state,direction)
    if state.center_x+ (direction*state.paddle_speed) >state.spacelimit[1] 
    and 
    state.center_x+ (direction*state.paddle_speed) <state.spacelimit[2] then
      return true
    else
      return false
    end
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

    if state.health<=0 then 
      state.islose=true
    end

		if btn(0) and inspace(state,-1)==true
    then
        state.angle-=state.paddle_rotatespeed

        if inanglelimit(state)==false  then
          state.angle+=state.paddle_rotatespeed
        end

        state.center_x -= state.paddle_speed
        state.turningleft=true
    elseif btn(1)  and inspace(state,1)==true
    then
      state.angle+=state.paddle_rotatespeed

      if inanglelimit(state)==false then
        state.angle-=state.paddle_rotatespeed
      end

      state.center_x += state.paddle_speed
      state.turningleft=false



    elseif btn(4) then
      state.angle+=state.paddle_rotatespeed
      if inanglelimit(state)==false then
        state.angle-=state.paddle_rotatespeed
      end
      elseif btn(5) then 
        state.angle-=state.paddle_rotatespeed
        if inanglelimit(state)==false then
          state.angle+=state.paddle_rotatespeed
        end 
    end

    king_update(state.king_state)
    audience_update(state.audience_state)


  end

  function ball_draw(state)
    palt(0)
    map()
    audience_draw(state.audience_state)
    king_draw(state.king_state)


    if state.islose then
      print("you lose",50,50,7)
    end


    foreach(state.balllist, function(o)
      spr(30+2*o.object_type,o.ballx,o.bally,2,2)
    end)

    draw_ui(state)

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
        
    if x<8
    then
        x=8
        vx*=-1
    elseif x>105 then
        x=104   
        vx*=-1            
    end
        
    local good_object = state.object_types[ballstate.object_type].good
    if y>90 then
      del(state.balllist,ballstate)
      if good_object then 
        state.health-=1
        y=90
        vy*=-1

        sfx(2)
        ballstateStr="drop_ground"
      else
        sfx(17)
        ballstateStr="badthings_drop_ground"
      end
    end
    
    x+=vx
    count_distance(x,y,state)



    if state.distance <13
    and x >= min(state.center_x-state.line_length* cos(state.angle),state.center_x+state.line_length* cos(state.angle))-2
    and x <= max(state.center_x-state.line_length* cos(state.angle),state.center_x+state.line_length* cos(state.angle))-2
    then
    local distanceneed
    distanceneed=13-state.distance
        y -= distanceneed*cos(state.angle)
        x	-=	distanceneed*sin(state.angle)
      
      if good_object then
        vx,vy=countcollision(vx,vy,state.angle)
        state.score+=1
        sfx(1)
        ballstateStr="collision"
      else 
        state.health-=1
        state.score-=5
        del(state.balllist,ballstate)
        sfx(17)
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

    if vy>-2 then
      vy=-3
    end
    return vx,vy

		end

    function draw_ui(state)
      for i=1,state.health do
        spr(73,85+i*8,20) 
      end
      rectfill(85, 13, 118, 19, 14)
      print("time: " .. state.time_limit - state.counter\30, 86, 14, 7)
    end
