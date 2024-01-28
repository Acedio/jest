
   
-- draw and pop up the message box
function cutscene_draw(s)
    cls()
    map()
   if s.new_scene then
    rectfill(2,2,mid(2,s.message_box_frame*6,126),2,2)
    rect(2,2,mid(2,s.message_box_frame*6,126),2,6)
    if s.message_box_frame > 21 then
        rectfill(2,2,126,mid(2,(s.message_box_frame-21)*3,64),2)
        rect(2,2,126,mid(2,(s.message_box_frame-21)*3,64),6)
    end
   else
    rectfill(2,2,126,64,2)
    rect(2,2,126,64,6)
    local new_string = sub(s.messages[dialog_i].message,1,mid(1,(s.message_box_frame)*0.8,#s.messages[dialog_i].message))
    dshad(new_string,5,5,10)
   end
   if s.messages[dialog_i].speaker == "king" then
    draw_king(s)
   elseif s.messages[dialog_i].speaker == "mc" then
    draw_mc(s)
   end
end

function intro_init()
    dialog_i = 1 -- each button press progresses to the next dialog
    music(-1)
    music(0, 1000) -- start cutscene music
    return {
        messages = {
                {message = "welcome new jester. \ni have brought you from the \nfuture to entertain me.\n\nnow juggle my trinkets!\njuggle like your life \ndepends on it!", speaker = "king"},
                {message = "wait, what? i have a \npresentation due today! \n\nand a nomikai tonight!", speaker = "mc"},
                {message = "caper for me fool! \n\nheads up! \ndrop them and i drop you!", speaker = "king"},
            },
            message_box_frame = 0,
            new_scene = true
    }
end

function win_init()
    dialog_i = 1 -- each button press progresses to the next dialog
    music(-1)
    music(2, 1000) -- start win music
    return {
        messages = {
                {message = "enough! \ncongratulations, you have \nimpressed me", speaker = "king"},
                {message = "does this mean i can go back \nhome to my own time now?", speaker = "mc"},
                {message = "proposterous! \ni want to throw more things \nat you tomorrow too! \n\ntake him away!", speaker = "king"},
                {message = "noooooooooo!", speaker = "mc"}
            },
            message_box_frame = 0,
            new_scene = true
    }
end

function lose_init()
    dialog_i = 1 -- each button press progresses to the next dialog
    music(-1)
    music(0, 1000) -- start cutscene music
    return {
        messages = {
                {message = "future man, \nyour skills are as sharp as a \nwooden spoon \n\nmy disappointment is \nimmeasurable", speaker = "king"},
                {message = "forgive me my liege, \ngive me another chance!", speaker = "mc"},
                {message = "fine \n\ni'll let you try once more\ndon't disappoint me!", speaker = "king"},
                {message = "thank you lord!", speaker = "mc"}
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
    if s.new_scene == false and (btnp(❎) or btnp(🅾️)) then
        if dialog_i < #s.messages then
            s.message_box_frame = 0
            dialog_i+=1
        else
            return true
        end
    end
    return false
end


-- draw the king
function draw_king(s)
    palt(0x0010)
    spr(140,102,48,4,4) --back
    spr(200,70,80,8,4) --legs
    spr(136,92,61,4,3) --head
    if band(s.message_box_frame\10, 1) == 1 then
        spr(184,92,77,2,1) -- mouth closed
        spr(186,69,89,2,1) -- breathing
    else
        spr(168,92,77,2,1) -- mouth open
    end
end
-- draw the main character
function draw_mc(s)
    palt(0x0010)
    if band(s.message_box_frame\10, 1) == 1 then
        spr(128,2,48,4,4,true) --body
        spr(192,2,80,4,4,true) --legs
    else
        spr(132,2,48,4,4,true) --body
        spr(196,2,80,4,4,true) --legs
    end
end

-- drop shadow
function dshad (str, x, y)
 print (str, x+1, y+1, 1)
 print (str, x, y, 10)
end

-- title screen init
function title_init()
    music(-1)
end

-- title screen update
function title_update()
    if btnp(❎) or btnp(🅾️) then
        return true
    else
        return false
    end
end

-- title screen draw
function title_draw()
    cls()
    title = "surely, you jest!" --16 characters
    for i = 1, 17 do
        t1 = time()*30 + i*4
        
        title_x = 30 + i*4 + cos(t1/120)*3
        title_y = 34 + cos(t1/50)*4
        print(title[i], title_x+1, title_y+1,2)
        print(title[i], title_x, title_y,10)
    end
    
    palt(8,true)
    for i=0,4 do
        spr(96,0+(i*32),1,4,2)
    end
    print("press ❎/🅾️ to start",29,101,2)
    print("press ❎/🅾️ to start",28,100,7)

    print("a game by black bear roll",19,71,2)
    print("a game by black bear roll",18,70,7)

    print("global game jam 2024",29,81,2)
    print("global game jam 2024",28,80,7)
end
