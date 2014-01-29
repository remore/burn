# -*- encoding: utf-8 -*-

declare do
  x 124
  y 116
end

scene do
  color :bg, :green, :lighter
  color :text, :white, :lightest
  color :sprite, :red
  label "NICHISAN", 8, 4 # 今文字化けしてるのは、showの前にppu_on_allしちゃってるからっぽい
  play "nochi_thema"
  wait 1000
  stop
  label "game over"
  #play "gameoverC"
  wait 100
  main_loop <<-EOH
    #inline "oam_spr(x,y,0x41,0,0);//0x40 is tile number, i&3 is palette"
    #sprite_set :x,:y,41
    x-=2 if is_pressed(:left)
    x+=2 if is_pressed(:right)
    y-=2 if is_pressed(:up)
    y+=2 if is_pressed(:down)
  EOH
end

music "gameoverC" do
  tempo :presto
  
  channel "piano" do
    c3
    d4
    segno
    e3
    d2
    dal_segno
    
  end
  
  channel "bass" do
    g :staccato
    g :tenuto
    segno
    g :staccato
    g
    dal_segno
    
  end
end


music "nochi_thema" do
  tempo :allegro
  channel "piano" do
    c2
    g2 4, :dotted
    rest 8
    e2 8
    f2 8
    a2 8
    c3 8
    f3 :half
    
    segno
    bs 4, :dotted
    bs 8
    c  :dotted
    d  8
#    to_coda
    es 
    es 
    dal_segno
#    coda
    f  4, :dotted
    d  :eighth, :staccato
    g  :half
    rest :half
    
    c  :half
    rest :half
    
    rest :quarter
    
    rest
#    coda "X"
#    
#    dal_segno "hogehoge"
  end
  
  channel "bass" do
    rest 4
    a  :half
    rest :half
    bs :half
    rest :half
    
    bs :half
    as :half
    
    g  :half
    c :half
    
    rest :quarter
    
    c
    d
    e
    f
  end
end
