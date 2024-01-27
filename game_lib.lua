function ball_init()
  local state = {
    balllist = {},
    center_x = 64,
    center_y = 80,
    line_length = 20,
    gravity = 0.1,
    bounce = -1,
    counter = 1,
    interval = 1 * 30 ,
    paddle_speed=1,
    angle=0,

    distance
  }
  return state
  end

  function ball_update(state)
    state.counter+=1
    if state.counter >= state.interval then
        add(state.balllist, {ballx=1,bally=1,ballvx=1,ballvy=0})
        state.counter = 0
    end    
    foreach(state.balllist, function(o)
        o.ballx,o.bally,o.ballvx,o.ballvy
        =ball(o.ballx,o.bally,o.ballvx,o.ballvy,state)
    end)




        
    if btn(0) then
        state.angle-=0.01
        state.center_x -= state.paddle_speed
    elseif btn(1) then
      state.angle+=0.01
      state.center_x += state.paddle_speed
    elseif btn(4) then
      state.angle+=0.01
      elseif btn(5) then 
        state.angle-=0.01			    
    end
    


  end

  function ball_draw(state)
    cls()             
    
    foreach(state.balllist, function(o)
        spr(1,o.ballx,o.bally)
    end)

    local x1, y1, x2, y2 = update_line_endpoints(state)
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

  function ball(x,y,vx,vy,state)  
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
        
        
        if y>90 then 
        y=90
        vy*=-1
        end
        
        x+=vx
        count_distance(x,y,state)
    if state.distance <12
    and x >= min(state.center_x-state.line_length* cos(state.angle),state.center_x+state.line_length* cos(state.angle))
    and x <= max(state.center_x-state.line_length* cos(state.angle),state.center_x+state.line_length* cos(state.angle))
    then
    local distanceneed
    distanceneed=13-state.distance
        y -= distanceneed*cos(state.angle)
        x	-=	distanceneed*sin(state.angle)
    
        vx,vy=countcollision(vx,vy,state.angle)
    end

    return x,y,vx,vy
    
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