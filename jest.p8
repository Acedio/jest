pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
#include extra_lib.lua
#include game_lib.lua
#include cutscene_lib.lua

kinganim = {}
state = "choose"
cutscene_state = {}
ball_state = {}
audience_state = {}
king_state = {}

function _init()
 music(2)
 kinganim = anim:new{
  frame:new{
   sprn=16,
   w=2,
   h=2,
   t=4
  },
  frame:new{
   sprn=18,
   w=2,
   h=2,
   t=4
  }
 }
end

function _update()
 if state == "choose" then
   kinganim:update()
   --check buttons, update state
   if btn(❎) then
     state = "game"
     ball_state = ball_init()
     audience_state = audience_init()
     king_state = king_init()
   elseif btn(🅾️) then
     state = "cutscene"
     cutscene_state = intro_init()
   end
 elseif state == "game" then
   ball_update(ball_state)
   audience_update(audience_state)
   king_update(king_state)
 elseif state == "cutscene" then
   cutscene_update(cutscene_state)
 else
   -- die
 end
end

function _draw()
  cls()
  if state == "choose" then
    map()
    kinganim:draw(10, 10)
  elseif state == "game" then
    ball_draw(ball_state)
    audience_draw(audience_state)
    king_draw(king_state)
  elseif state == "cutscene" then
    cutscene_draw(cutscene_state)
  else
    -- die
  end
end
-->8
bbox = {}

function bbox:new(o)
 o = o or {}
 setmetatable(o, self)
 self.__index = self
 return o
end

function bbox:l()
 return self.x
end

function bbox:r()
 return self.x+self.w
end

function bbox:u()
 return self.y
end

function bbox:d()
 return self.y+self.h
end

function bbox:ul()
 return {x=self.x,y=self.y}
end

function bbox:ur()
 return {x=self:r(),y=self.y}
end

function bbox:dl()
 return {x=self.x,y=self:d()}
end

function bbox:dr()
 return {x=self:d(),y=self:r()}
end

function bbox:center()
 return {x=self.x+self.w/2,
         y=self.y+self.h/2}
end

-- a2 > a1, b2 > b1
function spancol(a1,a2,b1,b2)
 if a1 > b1 then
  return spancol(b1,b2,a1,a2)
 end
 return b1 < a2
end

function rectcol(r1,r2)
 return spancol(r1.x,r1:r(),r2.x,r2:r())
    and spancol(r1.y,r1:d(),r2.y,r2:d())
end
-->8
v2 = {}

function v2:new(o)
 o = o or {}
 if #o == 2 then
  o = {x=o[1],y=o[2]}
 end
 setmetatable(o, self)
 self.__index = self
 return o
end

function v2:len()
 return sqrt(self.x^2 + self.y^2)
end

function v2.__add(a,b)
 return v2:new{
  a.x+b.x,
  a.y+b.y,
 }
end

function v2.__sub(a,b)
 return v2:new{
  a.x-b.x,
  a.y-b.y,
 }
end

function v2.__mul(i,v)
 return v2:new{
  i*v.x,
  i*v.y,
 }
end
-->8
frame = {}

function frame:new(o)
 o = o or {}
 setmetatable(o, self)
 self.__index = self
 return o
end

function frame:draw(x, y, flip_x, flip_y)
 spr(self.sprn, x, y,
     self.w, self.h,
     flip_x, flip_y)
end

anim = {}

function anim:new(o)
 o = o or {}
 setmetatable(o, self)
 self.__index = self
 self.frame_i = 1
 self.frame_t = 0
 return o
end

function anim:draw(x,y, flip_x, flip_y)
 self[self.frame_i]:draw(x,y, flip_x, flip_y)
end

function anim:update()
 self.frame_t += 1
 local frame = self[self.frame_i]
 if self.frame_t >= frame.t then
  --go to next frame
  self.frame_t = 0
  self.frame_i += 1
  if self.frame_i > #self then
    self.frame_i = 1
  end
 end
end
__gfx__
bbbbbbbbaab111bbbbbbbbbbaab111bbbbbbbbbbaab111bbbbb0bbbbbaab111bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbf00bbbbbb
bbbbbbbfffb111bbbbbbbbbfffb111bbbbbbbbbfffb111bbbbbb0bbbfffb111bbbbbbbb9bbbbbbbbbbbbbbbb9bbbbbbbbbbbbbbf00bbbbbbbbbbbbbff0bbbbbb
bbbbbb0f0ff111bbbbbbbb0f0ff111bbbbbbbb0f0ff111bbbbbbbbb0f0ff111bbbbbbb999bbbbbbbbbbbbbbb99bbbbbbbbbbbbbff0bbbfbbbbbfbbbff0bbbbbb
bbbbbbf4fff111bbbbbbbbf4fff111bbbbbbbbf4fff111bbbb00bbbf4fff111bbbbbbb999bbbbbbbbbbbbbb999bbbbbbbbbbbbbff0bbfbbbbbbbfbbfffbbbfbb
bbbbbf000f111bbbbbbbbf000f111bbbbbbbbf000f111bbbbbbbbbf000f111bbbbbbbbb999bbbbbbbbbbbb999bbbbbbbbbbfbbbfffbbfbbbbbbbfbbbfbbbfbbb
bbbbbbffff111bbbbbbbbbffff111bbbbbbbbbffff111bbbbbbb0bbfeef111bbbbbbbbb9a9bbbbbbbbbbbb9a9bbbbbbbbbbbfbbbfb66bbbbbbbbb66616bbfbbb
bbbbb88a88811bbbbbbbb88a88811bbbbbbbb88a88811bbbbbb0bb88a88811bbbbbbbbbaabbbbbbbbbbbbbbaabbbbbbbbbbbfbb616bbbbbbbbbbbbb61666bbbb
bbbbbbeeef811bbbbbbbbbeeff811bbbbbbbbbeeef811bbbbbbbbbbeeef811bbbbbbbbb44bbbbbbbbbbbbbb44bbbbbbbbbbbb66616bbbbbbbbbbbbb666bbbbbb
bbbbeeeeff881bbbbbbbbeeeef881bbbbbbbeeeeff881bbbbbbbbeeeeff881bbbbbbbbb44bbbbbbbbbbbbbb44bbbbbbbbbbbbbb666bbbbbbbbbbbbb666bbbbbb
bbbffffeee881bbbbbbbfffeee881bbbbbbffffeee881bbbbbbbffffeee881bbbbbbbbb44bbbbbbbbbbbbbb44bbbbbbbbbbbbbb666bbbbbbbbbbbbb666bbbbbb
bbb3333fff888bbbbbbb333fff888bbbbbb3333fff888bbbbbbb3333fff888bbbbbb00044000bbbbbbbb00044000bbbbbbbbbb0500bbbbbbbbbbbb0500bbbbbb
bb553333331888bbbb553333331888bbbb553333331888bbbbb553333331888bbbb0555445550bbbbbb0555445550bbbbbbbb052220bbbbbbbbbb052220bbbbb
bb113355311888bbbb113355311888bbbb113355311888bbbbb113355311888bbbb0555555550bbbbbb0555555550bbbbbbbb052220bbbbbbbbbb020220bbbbb
bb1111111111bbbbbb1111111111bbbbbb1111111111bbbbbbb1111111111bbbbbbb05555550bbbbbbbb05555550bbbbbbbbb020220bbbbbbbbbb022220bbbbb
bb111111111bbbbbbb111111111bbbbbbb111111111bbbbbbbb111111111bbbbbbbbb000000bbbbbbbbbb000000bbbbbbbbbb022220bbbbbbbbbb022220bbbbb
bb0bbbbbbb0bbbbbbb0bbbbbbb0bbbbbbb0bbbbbbb0bbbbbbbb0bbbbbbb0bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000bbbbbbbbbbbb0000bbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbb000bbbbbbbbbbbb4444bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0bb0bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb666bbbbb
bbbbb00b2b00bbbbbbbbb666666bbbbbbbbbbbbbbbbbbbbbbbbbbbbb09bbbbbbbbb0bbb0bbb0bbbbbbbbbbbbbbbbbbbbbbbbbb00000bbbbbbbbbb666bbb6bbbb
bbbb0bbbbbbb0bbbbbbbbb6446bbbbbbbbbbbbbbbbbbbbbbbbbbbbb0bbbbbbbbbbb0bb0bbbb0bbbbbbbb1111111bbbbbbbbbb0555550bbbbbbbbbbbbbbbb6bbb
bbb0bbbbbbbbb0bbbbbbbb6446bbbbbbbbb000bbbb000bbbbbbbbb000bbbbbbbbbbb0b0bbb0bbbbbbbb166666661bbbbbbbb055555550bbbbbbbbbbbbbbb6bbb
bbb44444444444bbbbbbbb6cc6bbbbbbbb0ddd0000ddd0bbbbbbbb050bbbbbbbbbbb0bb0bb0bbbbbbbb163333361bbbbbbb05555555550bbbbbbbbbbbbb656bb
bbb49999999994bbbbbbb6cccc6bbbbbbb0d0ddddddbd0bbbbbbb00000bbbbbbbbb0bb040bbbbbbbbbb16bbbbb61bbbbbb0555555555550bbbbbbbbbbb6665bb
bbb499999aa994bbbbbb6c7cccc6bbbbb0d000dddd8dad0bbbbb0555550bbbbbbbbbb04440bbbbbbbbb16bbbbb61bbbbbb0555556555550bbbbb6b6bbb5666bb
bbb49999fff994bbbbb6c7cccccc6bbbb0dd0ddddddcdd0bbbb075555550bbbbbbbb0444440bbbbbbbb166666661bbbbbb0555566655550bbbb5555bb6656bbb
bbb49990f0ff94bbbbb6c7cccccc6bbbb0dddd0000dddd0bbbb055555550bbbbbbbbb04440bbbbbbbbb160666661bbbbbb0555776555550bbbb6565b566656bb
bbb4999f4fff94bbbb6c7cccccccc6bb0ddddd0bb0ddddd0bbb075555550bbbbbbbb0444440bbbbbbbb100066861bbbbbb0557775555550bbbb55556656bbbbb
bbb499f000f994bbbb6c7cccccccc6bb0dddd0bbbb0dddd0bbb075555550bbbbbbb044444440bbbbbbb160668661bbbbbbb07777555550bbbbbb666666b6bbbb
bbb4999ffff994bbbb6c7cccccccc6bbb0dd0bbbbbb0dd0bbbb055555550bbbbbbb044444440bbbbbbb166666661bbbbbbbb077555550bbbbbbbbb66b6bbbbbb
bbb49999999994bbbbb6cccccccc6bbbbb00bbbbbbbb00bbbbbb0555550bbbbbbbbb0000000bbbbbbbbb1111111bbbbbbbbbb0755550bbbbbbbb66bb6bbbbbbb
bbb44444444444bbbbbb6cccccc6bbbbbbbbbbbbbbbbbbbbbbbbb00000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000bbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbb666666bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
ddd6666666666ddd5dddddddddddddddddddddddddddddd5333373333333733333337333888888883333933444dddddddddddd44433933339cccddddddddccca
ddddddd66ddddddd65dddddddddddddddddddddddddddd563333f3333333f3333333fa33888888883f93344ddd100000000001ddd44339f39cccccc76cccccca
ddddddd66dddddddd65ddddddddddd6666ddddddddddd56db33733333e3733333a37a9a38888888839944dd100000000000000001dd4499359cccc7666cccca5
ddddddd66ddddddddd65dddddddd66333366dddddddd56dddb3f3333e2ef3333a9af3a33888888883344d1000000000000000000001d443359ccccc76ccccca5
ddddddd66dddddddddd65dddddd6333333336dddddd56ddd3373b3333e73e3333a73333388888888934d100000000000000000000001d439559cccc76cccca55
ddddddd66ddddddddddd65dddd633333333336dddd56dddd33f3db3333fe2e3333fa33338888888834d10000000000000000000000001d435559cccccccca555
ddddddddddddddddddddd65dd63333333333336dd56ddddd373333333733e33337a9a3338888888834d00000000000000000000000000d43555599ccccaa5555
5555555335555555dddddd65633333333333333656dddddd3f3333333f3333333f3a3333888888884d1000000000000000000000000001d45555559999555555
6666666666666666ddddddd600000000555555556ddddddd33733b3333733c333337f333333f73334d0000004444444433333333000000d49eeeddddddddeeea
ddddddd66dddddddddddddd600000000555555556ddddddd33f3bd3333f3c1c3337337f33f7337334d0000004444444433333333000000d49eeeeee76eeeeeea
ddddddd66dddddddddddddd600000000555555556ddddddd3337333333373c333733333773333373d100000044444444333333330000001d59eeee7666eeeea5
ddddddd66dddddddddddddd600000000555555556ddddddd333f333333cf33337333733ff3373337d000000044444444333333330000000d59eeeee76eeeeea5
ddddddd66dddddddddddddd600000000555555556ddddddd333373333c1c73c3f33733f33f33733fd000000044444444333333330000000d559eeee76eeeea55
ddddddd66dddddddddddddd600000000555555556ddddddd3333f33333c3fc1c37337f3333f73373d000000044444444333333330000000d5559eeeeeeeea555
ddddddddddddddddddddddd600000000555555556ddddddd333b3733333337c33f333333333333f3d000000044444444333333330000000d555599eeeeaa5555
55555555555555555555555300000000555555553555555533bd3f3333333f3333f3333333333f33100000004444444433333333000000015555559999555555
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee1d33333333333dd11dd33333333333d18888888108888888888188888880888888888881118888888888888888888888
eeeeeeeeeeeeeeeaaeeeeeeeeeeeeeee11d333333333d111111d333333333d118888881000888888888108888801888888888811100888888888881118888888
eeeeeeeeeeeeeeeaaeeeeeeeeeeeeeef111dd33333dd11111111dd33333dd1118888810880888888888100888010888888888110000088888888811100888888
2eeeeeeeeeeeeeaaaaeeeeeeeeeeeeef11111ddddd111111111111ddddd111118888810810888888888810080108888888888110000088888888810000088888
82eeeeeeeeeeeeaaaaeeeeeeeeeeeef8111111111111111991111111111111118888880888888888888880111008888888888100000088888888806010088888
82eeeeeeeeeeeee99eeeeeeeeeeeeef8111111111111111991111111111111118888888008888888888811111000888888888100000088888888101001008888
882eeeeeeeeeaee99eeaeeeeeeeeef88111111111111119999111111111111118888881100088888888811110000008888888100001088888888100000008888
882eeeeeeeea9aeaaea9aeeeeeeeef88511111111111119999111111111111158888811100008888888811110006008888888100100088888888800000008888
8882eeeeeee9e9aaaa9e9eeeeeeef888511111111111111441111111111111158888111100060888888811100000008888881060010008888888880000000888
88882eeeeeeeee9aa9eeeeeeeeef8888351111111111911441191111111111538888111000000888888881000000088888880000010008888888888000800888
888882eeeeeeeee99eeeeeeeeef88888335111111119491991949111111115338888111000000888888888000000888888888000000088888888888110080088
88888822eeeeeeaaaaeeeeeeff888888333511111114149999414111111153338888810000008888888888800088888888888800000888888888881100008888
8888888822eeeee99eeeeeff88888888333351111111114994111111111533338888800000008888888881111100888888888880008888888888811000000888
888888888822eeeeeeeeff8888888888333335111111111441111111115333338888880000088888888811110000088888888111100088888888111000000888
88888888888822eeeeff888888888888333333511111119999111111153333338888811111008888888111000000008888881111000000888888110000000088
88888888888888222288888888888888333333351111111441111111533333338881111000000088888110000000008888811100000000888881000000000088
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbabbabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbabbabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbaababbaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb777faaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb777fffaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb7777bbbbbbbbbbbbbbbbbbbbbbbb77fffffff88aaafbbbbbbbbbbbbbbbbbb111111111bbbbbbbbbbb
bbbbbbbbbbbbbbb7777bbbbbbbbbbbbbbbbbbbbbbbbbb77ffff77bbbbbbbbbbbbbbbbbbbbbfffffffffffaaafffbbbbbbbbbbbbbbb111111111111111bbbbbbb
bbbbbbbbbbbbb77ffff77bbbbbbbbbbbbbbbbbbbbbbb7ffffffff00bbbbbbbbbbbbbbbbbf9ffffff9fffffffffffbbbbbbbbbbbbb11111111111111100bbbbbb
bbbbbbbbbbbb7ffffffff00bbbbbbbbbbbbbbbbbbbb7fffffff0000bbbbbbbbbbbbbbbb999fffff9999ffffffff99bbbbbbbbbbb111111111111111000bbbbbb
bbbbbbbbbbb7fffffff0000bbbbbbbbbbbbbbbbbbbbfffffff00000bbbbbbbbbbbbbb9911f9fffff1199ffff99999bbbbbbbbbbb1111111111111110000bbbbb
bbbbbbbbbbbfffffff00000bbbbbbbbbbbbbbbbbbbff0ff0ffff000bbbbbbbbbbbbfff111fffffff111f9ff99999ffbbbbbbbbb11111111111111100000bbbbb
bbfffbbbbbff0ff0ffff000bbbbbbbbbbbbbbbbbbbfffffffffff00fbbbbbfffbbffff111fffffff111fff999999fffbbbbbbbb11111111111111100000bbbbb
bffffbbbbbfffffffffff00fbbbbbbbbbbbbbbbbbbfffffffffff0ffbbbbbfffbbfffffffffffffffffffffff99ffffbbbbbbb2211111111111110000000bbbb
bb666bbbbbfffffffffff0ffbbbbbbbbbbbbbbbbbbbff0ffffff00ffbbbb6666bffffffff44ffffffffffffff9fffffbbbbbbb2221111111111120000000bbbb
bb666bbbbbbff0ffffff00ffbbbbbbbbbfffbbbbbbbff00fffff00fbbbbb6666bffffff4444fffffffffffffff9ffffbbbbbb22221111111111220000000bbbb
bbb666bbbbbff00fffff00fbbbbbbbbbbfffbbbbbbbbfeeffff00fbbbbb6666bbf9ffff4444fffffffffffffff9ffffbbbbbb22222111111111220000000bbbb
bbb666bbbbbbfeeffff00fbbbbbbbfffb6666bbbbbbbbeeffffffbbbb666666bbbffff5555ffff9fffffffffffffffbbbbbbb22222211111112220000000bbbb
bbbb666bbbbbbffffffffbbbbbbbbfffb6666bbbbbbbbbbffff61bb6666666bbbbf9ff5ff5fffffffffffffffffffbbbbbbbb22222211111122220000000bbbb
bbbb66666bbbbbbffff61bbbbbbb6666bb6666bbbbbbb661fff16666666666bbbbbffff55ff9fff9ffffffffffffbbbbbbbb222222221111122220000000bbbb
bbbbb66666bbb661fff16bbbbbbb6666bb6666bbbb666666111666666666bbbbbbbb9ffffffffffffffffffffffbbbbbbbbb222222221111222220000000bbbb
bbbbbb6666666666111666bbbbb6666bbbb66666666666611166666666bbbbbbbbbbbf9ff9fffffff9ffffffffbbbbbbbbbb222222222112222210000000bbbb
bbbbbbb6666666611166666bb666666bbbb666666666666116666666bbbbbbbbbbbbbbbbbbfff9ffffffffffbbbbbbbbbbbb222222222112222210000000bbbb
bbbbbbbbb666666116666666666666bbbbbbb666666666611666666bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb2222222221112222210000000bbbb
bbbbbbbbb666666116666666666666bbbbbbbbbb666666111666666bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbeebbb2222222221112222200000000bbbb
bbbbbbbbb6666611166666666666bbbbbbbbbbbbbb6666111666666bbbbbbbbbbfffff5555fff9ffbbbbbbbbbbeebbbbbbb222222222112222220000000bbbbb
bbbbbbbbbb6666111666666666bbbbbbbbbbbbbbbb6666116666666bbbbbbbbbbf9fffffffffffffbbbbbbbeeebbbbbbbbb222222221112222220000000bbbbb
bbbbbbbbbb6666116666666bbbbbbbbbbbbbbbbbbb666111666666bbbbbbbbbbbbffffffff9fff9fbbbbbeebbbbbbbbbbbb222222221112222220000000bbbbb
bbbbbbbbbb666111666666bbbbbbbbbbbbbbbbbbbb666111666666bbbbbbbbbbbbb9ffffffffffffbbbbebbbbbbbbbbbbbb222222221112222210000000bbbbb
bbbbbbbbbb666111666666bbbbbbbbbbbbbbbbbbbb661111666666bbbbbbbbbbbbbbf9ff9fffffffbbbebbbbbbbbbbbbbbb222222221112222210000000bbbbb
bbbbbbbbbb661111666666bbbbbbbbbbbbbbbbbbbbb61111666666bbbbbbbbbbbbbbbbbbbfff9fffbbebbbbbbbbbbbbbbb2222222211122222210000000bbbbb
bbbbbbbbbbb61111666666bbbbbbbbbbbbbbbbbbbbb66116666666bbbbbbbbbbbbbbbbbbbbbbbbbbbebbbbbbbbbbbbbbbb2222222211122222210000000bbbbb
bbbbbbbbbbb66116666666bbbbbbbbbbbbbbbbbbbbb6666666666bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb2222222211122222210000000bbbbb
bbbbbbbbbbb6666666666bbbbbbbbbbbbbbbbbbbbbb6666666666bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb2222222111122222210000000bbbbb
bbbbbbbbbbb6666666666bbbbbbbbbbbbbbbbbbbbbb666666666bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb2222222111122888110000000bbbbb
bbbbbbbbbbb666666666bbbbbbbbbbbbbbbbbbbbbbbb66666666bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb222222211122888881000000bbbbbb
bbbbbbbbbbbb55555555bbbbbbbbbbbbbbbbbbbbbbbb55555555bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb888888888888888888888888881000000bbbbbb
bbbbbbbbbbbb55555555bbbbbbbbbbbbbbbbbbbbbbb555555555bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb88888888888888888888888888888000000bbbbbb
bbbbbbbbbbb5555555555bbbbbbbbbbbbbbbbbbbbb55555555555bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbeeee88888888888888888888fff888000000bbbbbb
bbbbbbbbbbb5555555555bbbbbbbbbbbbbbbbbbbbb55555555555bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbeeeeeeee8888888888888888effff888000000bbbbbb
bbbbbbbbbb55555055555bbbbbbbbbbbbbbbbbbbb555555055555bbbbbbbbbbbbbbbbbbbbbbbbbbbbbeeeeeeeeeeeeeeeeeeeeeeeeeeeffff888000000bbbbbb
bbbbbbbbb555555055555bbbbbbbbbbbbbbbbbbb5555555055555bbbbbbbbbbbbbbbbbbbbbbbbbeeeeeeeeeeeee55ee5eeeeeeeeeeeefffff888000000bbbbbb
bbbbbbbbb555550555555bbbbbbbbbbbbbbbbbbb5555550555555bbbbbbbbbbbbbbbbbbbbbeeeeeeeeeeeeeeeeeee55eeeeeeeeeeeeeffffff88000000bbbbbb
bbbbbbbb555555b55555bbbbbbbbbbbbbbbbbbb5555555b55555bbbbbbbbbbbbbbbbbbbeeeeeeeeeeeeeeeee55555e555eeeeeeeeeeeffffff8800000bbbbbbb
bbbbbbbb55555b555555bbbbbbbbbbbbbbbbbbb555555b555555bbbbbbbbbbbbbbbbbeeeeeeeeeeeeeeeeeeeeeeee5eeeeeeeeeeeeeffffffff800000bbbbbbb
bbbbbbbb55555b55555bbbbbbbbbbbbbbbbbbbb55555bb555555bbbbbbbbbbbbbbbbeeeeeeeeeeeeeeeee55eee5e5eeeeeeeeeeeeeefffffffff00000bbbbbbb
bbbbbbb55555555555bbbbbbbbbbbbbbbbbbbbb555555bb5555bbbbbbbbbbbbbbbbeeeeeeeeeeeeeee555ee5eee5eeeeeeeeeeee9efffffffff000000bbbbbbb
bbbbbbb55555b5555bbbbbbbbbbbbbbbbbbbbbbb555555b5555bbbbbbbbbbbbbbbeeeeeeeeeeeeeeeeeee5ee5eeeeeeeeeeeeeeff9fffffffff000000bbbbbbb
bbbbbbb5555500000bbbbbbbbbbbbbbbbbbbbbbbb5555500055bbbbbbbbbbbbbbeeeeeeeeeeeeeeeeeeeee555eeeeeeeeeeee9fff9fffffffff000000bbbbbbb
bbbbbbb555552222200bbbbbbbbbbbbbbbbbbbbbbb555552200bbbbbbbbbbbbbfeeeeeeeeeeee55eeeee555eeeeeeeeeee9eff9fffffffffff1000000bbbbbbb
bbbbbbbb555552222220bbbbbbbbbbbbbbbbbbbbb0255ff22220bbbbbbbbbbbbffeeeeeeee555ee5ee55eeeeeeeeeeeffff9ff9fffffffffff1000000bbbbbbb
bbbbbbbb5555522222220bbbbbbbbbbbbbbbbbbb02222fff22220bbbbbbbbbbbfffeeeeeeeeeeeee5eeeeeeeeeeeeffffff9fffffffffffff11000000bbbbbbb
bbbbbbb055555222222220bbbbbbbbbbbbbbbbb0222222ff222220bbbbbbbbbbffffeeeeeeeeeee55eeeeeeeeeeeffffffffffffffffffff111000000bbbbbbb
bbbbbbb025555522222220bbbbbbbbbbbbbbbbb022222fff222220bbbbbbbbbbfff5ffeeeeee555eeeeeeeeeeeeffffffffffffffff11111111000000bbbbbbb
bbbbbb02255555222222220bbbbbbbbbbbbbbb02222222002222220bbbbbbbbb3f5ffffeee55eeeeeeeeeeeeeeffffffff11111111111111111000000bbbbbbb
bbbbbb02225555522222220bbbbbbbbbbbbbbb02222222222222220bbbbbbbbb33fffffffeeeeeeeeeeeeeeee1fffffff111111111111111111000000bbbbbbb
bbbbbb0222255ff22222220bbbbbbbbbbbbbbb02222222222222220bbbbbbbbb333ffffffffeeeeeeeeeeeee11ffff111111111111111111111000000bbbbbbb
bbbbbb0222222fff2222220bbbbbbbbbbbbbbb02222222222222220bbbbbbbbb3333ffffffffeeeeeeeeeee001111111111111111111100000000000bbbbbbbb
bbbbbb02222222ff2222220bbbbbbbbbbbbbbb02222222222222220bbbbbbbbb33333fffffffffeeeeeeeee000111111111111111000000000000000bbbbbbbb
bbbbbbb022222fff222220bbbbbbbbbbbbbbbbb022222222222220bbbbbbbbbb3333333ffffffffffeeeeee000000111111000000ffff00000000000bbbbbbbb
bbbbbbb022222200222220bbbbbbbbbbbbbbbbb022222222222220bbbbbbbbbb333333333ffffffffffffee000000111000f000ffffff00000000000bbbbbbbb
bbbbbbbb0222222222220bbbbbbbbbbbbbbbbbbb0222222222220bbbbbbbbbbb333333333333fffffffffffff0000000ffff000ffffff00000000000bbbbbbbb
bbbbbbbbb02222222220bbbbbbbbbbbbbbbbbbbbb02222222220bbbbbbbbbbbb333333333333333ffffffffffffffffffffff000fff3000000000000bbbbbbbb
bbbbbbbbbb002222200bbbbbbbbbbbbbbbbbbbbbbb002222200bbbbbbbbbbbbb33333333333333333333333333333333333330003330000000000000bbbbbbbb
bbbbbbbbbbbb00000bbbbbbbbbbbbbbbbbbbbbbbbbbb00000bbbbbbbbbbbbbbb33333333333333333333333333333333333330003330000000000000bbbbbbbb
__map__
42435c5c5c5c5c5c5c5c5c5c5c5c444500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
52595c5c5c595c5c5c5c5c5c5c5c585500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40585c5c5c584a4b4c4d585c5c5c594100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
50565c5c5c565a53535d565c5c5c475100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40465c5c5c4753535353485c5c5c564100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
50575c5c5c5653535353565c5c5c465100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40465c5c5c4664656667465c5c5c574100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
50565c5c5c5674757677565c5c5c465100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40485c5c5c465c74775c475c5c5c564100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
50575c5c5c575c5c5c5c565c5c5c475100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40465c5c5c485c5c5c5c485c5c5c574100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
50565c5c5c565c5c5c5c565c5c5c465100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
405b5b5b5b5b5b5b5b5b5b5b5b5b5b4100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
505b5b5b5b5b5b5b5b5b5b5b5b5b5b5100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5e5f4e4f5e5f4e4f5e5f4e4f5e5f4e4f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5454545454545454545454545454545400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
3006000015201152010e211182212625128231232010d001162010a2011a27112251112710820106201172511627105201132311423114231142311320114201192011a2010a2010a2010a2010a2010a2010a201
000100000002000020000300104004050060500d050140501c0602907000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200002e15024150111500b15004150011500015000150011500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
891000042e235302352b2352823500205002050020500205002050020500205002050020500205002050020500205002050020500205002050020500205002050020500205002050020500205002050020500205
001000100113501125011250112501125011250112501125001350012500125001250012500125001250012524105001050010500105001050010500105001050010500105001050010500105001050010500105
001000080847500405004050040506455054050345500405004050040500405004050040500405004050040500405004050040500405004050040500405004050040500405004050040500405004050040500405
501000102e2452e27530205302052e2752e2452e2352c2352f2252f2452b2252d23527245302552b27513275242452b205242552c2052125523255212551c25522255202551b2552025527255202551d25517255
041000080415504165041250411502155021650212502115111050610505105041050010500105001050010500105001050010500105001050010500105001050010500105001050010500105001050010500105
041000080c67525605006050f6450c655006051b6551a6051a6050060500605006050060500605006050060500605006050060500605006050060500605006050060500605006050060500605006050060500605
361000080307000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08140020297122e72230732307323375233772337722e7522b7322b712297322970229732297322e7422e7022e7422e762307723376230702307523371233712357223776233722337323374235762377423a762
101400100a1550a1050a1350a1050a1250a1050a1250a1050715507105071250710507125071050712507105051251e1152a15530115371152b1152e115311152b1552f155271352915539155331553615531155
4e1400203a67506605276052e655286653a6050165508655046550060528655006051e6552965524655266552065500605116552f6650060513655226450c6650060500605176551c665166551a6551967514655
d014002000700007003575000700007003e75000700007000070000700007002f70000700007003d7500070000700007000070000700007000070000700007003875000700007000070000700007003e75000700
__music__
07 43044544
03 06070809
03 0a0b0c4d

