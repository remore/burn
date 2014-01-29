# -*- encoding: utf-8 -*-

# toucn=collision flag, frame=frame counter
declare do
  i 0
  touch 0
  frame 0
  catB_x 180
  catB_y 100
  x 0
  
  egg <<-EOS
        
 122221 
 1    1 
 1 33 1 
 1 33 1 
 1    1 
 122221 
        
EOS

  super_egg <<-EOS
    32123212    
  111111111111  
 22222222222222 
 33333333333333 
 22222222222222 
 33333333333333 
 11111111111111 
  222222222222  
EOS

  metaCat <<-EOS
  2222  33333333
 222222 33333333
 222222         
2222222233333333
2222222233333333
2222222233333333
 311113 33333333
  1111  33333333
1 2222  22222222
 222222 33333333
 222222 11111111
2222222233322222
22222222333   33
22222222333   33
 311113 333   33
1 1111  33333333
EOS

end

music "finish" do
  tempo :allegro
  channel "piano" do
    segno
    e3
    e3
    f3
    g3
    g3
    f3
    e3
    d3
    c3
    c3
    d3
    e3
    e3 :dotted
    d3 :eighth
    d3
    rest
    dal_segno
  end
end

music "news" do
  tempo :presto
  channel "piano" do
    segno
    d2
    g2
    g2
    a2
    a2
    b2 :half
    rest
    a2 :eighth
    b2 :eighth
    c3
    c3
    d3
    a2
    b2 :half
    rest
    b2 :eighth
    d3 :eighth
    e3
    e3
    gs3
    gs3
    g3 :half
    rest
    b2 :eighth
    a2 :eighth
    g2
    g2
    a2
    a2
    g2 :half
    rest
    dal_segno
  end
  
  channel "bass" do
    segno
    rest
    e :half
    gs :half
    g :half
    rest :half
    a :half
    gs :half
    g :half
    rest :half
    c2 :half
    d2 :half
    e2 :half
    rest :half
    c :half
    d :half
    g :half
    rest
    dal_segno
  end
end

scene do
  color :bg, :blue, :lighter
  color :text, :green, :darker
  inline "pal_col(2,0x15);"
  label "HELLO, WORLD!", 2, 2 # 変数は使えない. 使えるのはmain_loopの中のみ。
  label "THIS CODE PRINTS SOME TEXT", 2, 4
  play "news"
  main_loop <<-EOH
#    wait "metaCat.x" # 変数を使う(:vcall)ときは文字列で渡す
#    metaCat.x = 100 # :assignオペレーションの時のみこんな感じで書く
#    #show "SCORE: %d%d%d", 2, 22, "x/100", "x/10%10", "x%10"
#    sprite "metaCat" # Stringでもいい --- sprite "metaCat"のように
#    if is_pressed(:right) then
#      metaCat.x+=2
#    end
#    if x==100 then
#      #wait 100
#      #stop
#      goto "test"
#    end
#    x+=1

    show "SCORE: %d%d%d", 2, 22, "x/100", "x/10%10", "x%10"
    sprite "metaCat"
    metaCat.x-=2 if is_pressed(:left) && metaCat.x>0
    metaCat.x+=2 if is_pressed(:right) && metaCat.x<232
    if (is_pressed(:up) && metaCat.y>0) then
      metaCat.y-=2
    elsif metaCat.y<210 then
      metaCat.y+=2
    end
    metaCat.y+=2 if is_pressed(:down) && metaCat.y<232
    if is_pressed(:a) then
      if x<5 then
        egg.x = metaCat.x
        egg.y -= 4
        sprite "egg"
      else
        if x==5 then
          stop
          goto "test"
        end
        super_egg.x = egg.x
        super_egg.y -= 6
        sprite "super_egg"
      end
    else
      egg.y = 230
    end
    sprite "metaCat"
    
    if !true then
      #test comment
    end
    if !(egg.x+22< catB_x+2 or egg.x+2>=catB_x+22|| egg.y+22< catB_y+2 || egg.y+2>=catB_y+22) then
      if touch==0 then
        x+=1
        touch=1
      end
    else
      touch=0;
    end
    frame+=1
  EOH
end

scene "test" do
  color :bg, :black
  label "HEY YO MEN", 7, 8
  play "finish"
  main_loop <<-EOH
    show "YES, RIGHT: %d", 3, 5, "touch"
    metaCat.y+=1 if is_pressed(:down)
    sprite :metaCat
  EOH
end
