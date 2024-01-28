function king_init()
  return {
    t = 0,
    x = 64-8,
    y = 32,
  }
end

function king_update(s)
  s.t += 1
  if band(s.t, 127) == 0 then
    sfx(0)
  end
end

function king_draw(s)
  palt(0x0010)
  local laugh = band(s.t,127)
  if laugh > 6 and laugh < 32 then
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
    spr(104+2*(i%4),i*16,112,2,2)
  end
  --curtains
  for i=0,2 do
    spr(96,16+32*i,0,4,2)
  end
end
