
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
  
  tile <<-EOH
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
  color :bg, :orange, :lighter
  
  color :palette_x1, :deepred, :darker
  color :palette_x2, :bluegreen, :darker
  paint range("44px", "5px", "120px", "60px"), :palette_x

  color :palette_y2, :pink, :darkest
  paint range(30, 2, 30, 12), :palette_y

  screen <<-EOH, { A:"tile", B:"wave", C:"mountain"}
                                
 AAAA  AA     AAA    AAA  AA  A 
 AA  A AA    AA AA  AA AA AA A  
 AA  A AA   AA   AA AA    AAA   
 AAAAA AA   AA   AA AA    AA    
 AA  A AA   AAAAAAA AA    AAA   
 AA  A AA   AA   AA AA AA AA A  
 AAAA  AAAA AA   AA  AAA  AA  A 
                                
 BB   BB    BB   BBB   BBBBB    
 BB   BB    BB  BB BB  BB  BB   
  BB BB BB BB  BB   BB BB  BB   
  BB BB BB BB  BBBBBBB BBBB     
   BB    BB    BB   BB BB  BB   
   BB    BB    BB   BB BB  BB   
EOH

  label "press start", 10, 20
  play "sarabande"
  
  main_loop <<-EOH
    frame+=1
    if frame==50 then
      color :palette_x1, :pink, :lighter
    end
    if (frame%30)==1 then
      if color_flag%2 then
        color :text, :white
        color :palette_y2, :pink, :darkest
      else
        color :text, :orange, :lighter
        color :palette_y2, :pink, :lighter
      end
      color_flag+=1
    end
    
    if is_pressed(:start) then
      sound "change"
      stop
      frame=0
      player.y=220
      fade_out 5
      wait 100
      goto "game"
    end
  EOH
end

scene "game" do
  play "battle"
  color :bg, :black
  color :text, :white
  fade_in
  label "hello", 3, 3
  main_loop
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
