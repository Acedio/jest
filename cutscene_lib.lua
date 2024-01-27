
-- creates the text box, message, draws the speaker
function cutscene(s)
    message_box_draw(s)
    if s.messages[1].speaker == "king" then
     draw_king()
    elseif s.messages[1].speaker == "mc" then
    draw_mc()
    end
end
   
-- draw and pop up the message box
function message_box_draw(s)
   if s.new_scene then
    rectfill(2,2,mid(2,s.message_box_frame*6,126),2,13)
    rect(2,2,mid(2,s.message_box_frame*6,126),2,6)
    if s.message_box_frame > 21 then
        rectfill(2,2,126,mid(2,(s.message_box_frame-21)*3,64),13)
        rect(2,2,126,mid(2,(s.message_box_frame-21)*3,64),6)
    end
   else
    rectfill(2,2,126,64,13)
    rect(2,2,126,64,6)
    local new_string = sub(s.messages[1].message,1,mid(1,(s.message_box_frame)*0.5,#s.messages[1].message))
    dshad(new_string,5,5,10)
   end
end

function intro_init()
    return {
        messages = {
                {message = "hello new jester. \ni have brought you from the \nfuture to entertain me.\n\nnow juggle!\njuggle like your life \ndepends on it!", speaker = "king"}
            },
            message_box_frame = 0,
            new_scene = true
    }
end

function cutscene_update(s)
    s.message_box_frame += 1
    if s.new_scene and s.message_box_frame > 42 then
        s.new_scene = false
        s.message_box_frame = 0
    end
    if btn(4) or btn(5) then
        print("yay")
    end
end


-- draw the king
function draw_king()
-- will need to change king sprites in final
 spr(7,84,36,6,4)
 spr(69,68,68,8,4)
end

-- draw the main character
function draw_mc()
-- will need to change sprites in final
 spr(1,2,36,4,4)
 spr(69,68,68,8,4)
end
-- drop shadow
function dshad (str, x, y)
 print (str, x+1, y+1, 1)
 print (str, x, y, 10)
end