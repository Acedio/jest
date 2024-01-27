
   
-- draw and pop up the message box
function cutscene(s)
    cls()
   if s.new_scene then
    rectfill(2,2,mid(2,s.message_box_frame*6,126),2,13)
    rect(2,2,mid(2,s.message_box_frame*6,126),2,6)
    if s.message_box_frame > 21 then
        rectfill(2,2,126,mid(2,(s.message_box_frame-21)*3,64),13)
        rect(2,2,126,mid(2,(s.message_box_frame-21)*3,64),6)
    end
   else
    cls()
    rectfill(2,2,126,64,13)
    rect(2,2,126,64,6)
    local new_string = sub(s.messages[dialog_i].message,1,mid(1,(s.message_box_frame)*0.8,#s.messages[dialog_i].message))
    dshad(new_string,5,5,10)
   end
   if s.messages[dialog_i].speaker == "king" then
    draw_king()
   elseif s.messages[dialog_i].speaker == "mc" then
    draw_mc()
   end
end

function intro_init()
    dialog_i = 1 -- each button press progresses to the next dialog
    return {
        messages = {
                {message = "hello new jester. \ni have brought you from the \nfuture to entertain me.\n\nnow juggle!\njuggle like your life \ndepends on it!", speaker = "king"},
                {message = "now i continue talking \nto check if this works", speaker = "king"},
                {message = "sounds good", speaker = "mc"},
                {message = "yep", speaker ="king"}
            },
            message_box_frame = 0,
            new_scene = true,
    }
end

function cutscene_update(s)
    s.message_box_frame += 1
    if s.new_scene and s.message_box_frame > 42 then
        s.new_scene = false
        s.message_box_frame = 0
    end
    if s.new_scene == false and btnp(4) or btnp(5) then
        cls()
        if dialog_i < #s.messages then
            s.message_box_frame = 0
            dialog_i+=1
        else
            -- return change state to game mode
        end
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
end

-- drop shadow
function dshad (str, x, y)
 print (str, x+1, y+1, 1)
 print (str, x, y, 10)
end