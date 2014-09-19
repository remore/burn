
sound "change" do
  effect do
    duty_cycle :higher
    velocity 15
    envelope_decay :disable # disabled by default
    length 5
    pitch 200
  end
  effect do
    length 4
    pitch 100
  end

end

sound "attack" do
  effect do
    duty_cycle :higher # accepts: :highest, :lowest etc ... but short/long is also possible for here
    velocity 15 # 7 by default
    envelope_decay :disable # disabled by default
    length 10 #raige: 1-254
    pitch 200
  end
  effect do
    length 11
    pitch 100
  end
  effect do
    pitch 50
  end
end


sound "finish" do
  effect do
    duty_cycle :highest # accepts: :highest, :lowest etc ... but short/long is also possible for here
    velocity 10 # 7 by default
    envelope_decay :disable # disabled by default. # disabled is not working. TBD(o be debugged)
    length 20 #raige: 1-254
    pitch 90
  end
  effect do
    length 15
    pitch 100
  end
  effect do
    pitch 90
  end
end

music "foobarpurple" do
  tempo :allegro
  channel "string" do
    g2 :sixteenth, :accent
    bs2 :sixteenth, :accent
    a2 :sixteenth, :tenuto
    g2 :sixteenth, :tenuto
    c3 :eighth, :dotted
    g2 :sixteenth, :accent
    
    bs2 :sixteenth, :accent
    a2 :sixteenth, :tenuto
    g2 :sixteenth, :tenuto
    c3 :eighth
    g2 :sixteenth, :tenuto
    bs2 :eighth
    
    g2 :sixteenth, :accent
    bs2 :sixteenth, :accent
    a2 :sixteenth, :tenuto
    g2 :sixteenth, :tenuto
    c3 :eighth, :dotted
    g2 :sixteenth, :accent
    
    bs2 :sixteenth, :accent
    a2 :sixteenth, :tenuto
    g2 :sixteenth, :tenuto
    f2 :eighth
    rest :sixteenth
    
    g2 :sixteenth, :accent
    bs2 :sixteenth, :accent
    a2 :sixteenth, :tenuto
    g2 :sixteenth, :tenuto
    c3 :eighth, :dotted
    g2 :sixteenth, :accent
    
    bs2 :sixteenth, :accent
    a2 :sixteenth, :tenuto
    g2 :sixteenth, :tenuto
    c3 :eighth
    g2 :sixteenth, :tenuto
    bs2 :eighth
    
    g2 :sixteenth, :accent
    bs2 :sixteenth, :accent
    a2 :sixteenth, :tenuto
    g2 :sixteenth, :tenuto
    c3 :eighth, :dotted
    g2 :sixteenth, :accent
    
    bs2 :sixteenth, :accent
    a2 :sixteenth, :tenuto
    g2 :sixteenth, :tenuto
    f2 :eighth
    rest :sixteenth
  end
  
  channel "bass" do
    rest :sixteenth
    rest :sixteenth, :triplet
    rest
    rest
    
    rest
    rest
    
    rest
    rest
    
    rest
    rest :sixteenth
    f1 :sixteenth
    f1 :sixteenth
    gs1 :sixteenth
    
    g1 :half
    g1 :half
    g1 :half
  end
end


# Thanks Handel http://www.youtube.com/watch?v=Js3y6ouy1rQ&feature=youtu.be
music "sarabande" do
  tempo :allegro
  channel "string" do
    d2   :eighth
    rest :eighth
    d2   :eighth
    rest
    d2   :eighth
    
    a1   :eighth
    rest :eighth
    a1   :eighth
    bs1  :eighth
    a1   :eighth
    g1   :eighth
    
    f1   :eighth
    rest :eighth
    f1   :eighth
    rest
    f1   :eighth
    
    c2   :eighth
    rest :eighth
    c2   :eighth
    c2   :eighth
    bs1  :eighth
    a1   :eighth
    
    g1   :eighth
    rest :eighth
    g1   :eighth
    rest 
  end
  
  channel "piano" do
    f3    :eighth
    rest  :eighth
    f3    :eighth
    rest
    g3    :eighth
    e3    :eighth
    rest  :eighth
    e3    :eighth
    rest  :eighth
    rest
    a3    :eighth
    rest  :eighth
    a3    :eighth
    rest
    bs3   :eighth
    g3    :eighth
    rest  :eighth
    g3    :eighth
    rest
    a3    :eighth
    bs3   :eighth
    rest  :eighth
    bs3   :eighth
    rest
    
  end
end

music "battle" do
  tempo :presto
  channel "piano" do
    segno
    e2 :staccato
    rest
    e2 :staccato
    rest
    f2 :staccato
    rest
    f2 :staccato
    dal_segno
  end
  channel "string" do
    segno
    g
    rest
    f
    rest
    e
    rest
    d
    dal_segno
  end
end

declare do
  frame 0
  color_flag 0
  speed 3
  score 0
  time 15
  is_attacking 0
  stage 1
  delta 0
  
  block <<-EOH
11111111
11222211
11233211
11233211
11233211
11233211
11222211
11111111
EOH

  wave <<-EOH
3333333  
3333333  
  1111111
  1111111
    22222
     2222
      111
        1
EOH

  mountain <<-EOH
   11    
  2222   
 22222   
 222222  
3333333  
33333333 
333333333
333333333
EOH

  ruby <<-EOH
  1111  
22222222
22222222
 222222 
 222222 
  2222  
  2222  
   22   
EOH

  star <<-EOH
                
       11       
       11       
      1111      
      1111      
1111111111111111
 11111111111111 
  111111111111  
   1111111111   
    11111111    
    11111111    
    11111111    
   1111  1111   
   11      11   
  1          1  
                
EOH

  player <<-EOS
  22   33   33  
 122   33   331 
 122  1331  331 
 1221 1331 1331 
1122111331113311
1322313333133331
1322313333333331
1122111331113311
1122111331113311
1322313333133331
1322313333333331
1122111331113311
  22   33   33  
 122   33   331 
 122  1331  331 
 1221 1331 1331 
EOS

  boss <<-EOS
       1       1        
      11      11        
 3    1122    112       
 32   112222  11222     
 3222 11222233112211    
 332222111223311122111  
 3332   1112233   2211  
 1133 2 2111223 1 22212 
  133   1112233   22112 
 1333221112223112221123 
 3332211122231122211223 
 33 221112 23112 21122  
 33  2111   311   1122  
  3    11   3       12  
  3    11   3       12  
            3           
EOS

end

scene "title" do
  color :bg, :lightorange, :lightest
  
  color :palette_x1, :blue, :lighter
  color :palette_x2, :blue, :lighter
  color :palette_x3, :blue, :lighter
  
  color :palette_y1, :deepred, :lighter
  color :palette_y2, :deepred, :darker
  color :palette_y3, :deepred, :darker
  paint range("0px", "0px", "250px", "100px"), :palette_y

  color :palette_z1, :gray, :lightest
  color :palette_z2, :black
  color :palette_z3, :black
  paint range(0, 11, 30, 12), :palette_z

  screen <<-EOH, { A:"ruby", B:"block", C:"mountain"}
  BBB  B B BBB  B B   B   B     
  B  B B B B  B B BB BB  B B    
  B  B B B B  B B BBBBB  B B    
  BBB  B B BBB  B B B B B   B   
  B B  B B B  B B B   B BBBBB   
  B  B B B B  B B B   B B   B   
  B  B  B  BBB  B B   B B   B   
                                
  A  A  A   A   AAA   AAA  AA   
  A  A  A  A A  A  A A     AA   
  A  A  A A   A A A  AAAA  AA   
   A A A  AAAAA AA       A AA   
   AA AA  A   A A A  A   A      
   AA AA  A   A A  A  AAA  AA   
                                
EOH

  label "press start", 10, 20
  play "sarabande"
  
  main_loop <<-EOH
    frame+=1
    if (frame%30)==1 then
      star.x = rand
      star.y = rand % 50 + 50
      if color_flag%2 then
        color :text, :white
      else
        color :text, :deepred, :darker
      end
      color_flag+=1
    end
    sprite "star"
    
    if is_pressed(:start) then
      sound "change"
      stop
      frame=0
      player.y=220
      fade_out 5
      wait 100
      goto "prep_1st"
    end
  EOH
end

scene "prep_1st" do
  color :bg, :black
  color :text, :white
  label "1st stage", 12, 13
  label "outbreak", 12, 16
  fade_in
  wait 600
  fade_out 5
  goto "game"
end

scene "prep_2nd" do
  color :bg, :lightblue, :darker
  color :text, :white
  label "2nd stage", 12, 13
  label "broken time", 11, 16
  fade_in
  wait 600
  fade_out 5
  goto "game"
end

scene "prep_3rd" do
  color :bg, :deepred, :darker
  color :text, :white
  label "3rd stage", 12,13
  label "out of control", 10, 16
  fade_in
  wait 600
  fade_out 5
  goto "game"
end

scene "prep_4th" do
  color :bg, :white, :darkest
  color :text, :white
  label "final stage", 11,13
  label "crash", 13, 16
  fade_in
  wait 600
  fade_out 5
  goto "game"
end

scene "game" do
  play "battle"
  fade_in
  label "hello", 3, 3
  main_loop <<-EOH
    if frame>=100 then
      if stage==2 then
        time-=rand%2+1
      else
        time-=1
      end
      frame=0
      boss.x=rand
      boss.y=rand
    else
      frame+=1
    end
    
    if time==0 then
      stop
      goto "game_over"
    end
    
    sprite "boss"
    show "TIME:%d%d SCORE:%d%d SPEED:%d", 2, 2, time/10%10, time%10, score/10%10, score%10, speed/3
    if stage <=3 then
      player.x-=2 if is_pressed(:left) && player.x>0
      player.x+=2 if is_pressed(:right) && player.x<232
    else
      delta = rand
      player.x-=delta%3 if delta%2
      delta = rand
      player.x+=delta%3 if delta%2
    end
    sprite "player"
    
    if is_pressed(:a) and is_attacking==0 then
      is_attacking=1
      mountain.x=player.x
      mountain.y=220
      if stage>=3 then
        speed = rand % 5
      end
    end
    
    if is_attacking>0 then
      is_attacking+=1
      mountain.y-=speed
      if mountain.y>0 then
        if mountain.y>=boss.y && mountain.y<=boss.y+16 &&
          mountain.x>=boss.x && mountain.x<=boss.x+24 then
          sound 'attack'
          is_attacking=0
          star.x = mountain.x-4
          star.y = mountain.y
          sprite "star"
          score+=6-(speed/3)
          if score >100 then
            stop
            
            time=15
            score=0
            frame=101
            stage+=1
            
            if stage==2 then
              goto "prep_2nd"
            elsif stage==3 then
              goto "prep_3rd"
            elsif stage==4 then
              goto "prep_4th"
            else
              goto "game_clear"
            end
          end
        else
          sprite "mountain"
        end
      else
        is_attacking=0
      end
    else
      if is_pressed(:up) && speed<15 then
        speed+=1
      elsif is_pressed(:down) && speed>1 then
        speed-=1
      end
    end
  EOH
end

scene "game_over" do
  color :bg, :red
  color :text, :white
  label "you LOSE", 2, 2
  sound "finish"
end

scene "game_clear" do
  color :bg, :blue
  color :text, :white
  label "you WIN", 2, 2
  sound "finish"
end
