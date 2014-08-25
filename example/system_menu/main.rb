config :app do
  target :telnet
  user_input :enable
  width 73
  height 13
end

declare do
  player <<-EOH
@-
@@--
@-
EOH
  enemy <<-EOH
XXX
 CXX
XXX
EOH
  blocker "%"
  shoot ">>>"
  shoot_flag 0
end

scene "main" do
  color :bg, :black
  color :text, :white
  label "Action?", 2, 2
  label "Choose one of following options:", 2, 3
  label "--------------", 2, 4

  label "(a) Print ruby version", 2, 6
  
  label "(b) Play mini-game", 2, 8
  
  main_loop <<-EOH
    goto "option_a" if is_pressed(:a)
    goto "option_b" if is_pressed(:b)
  EOH
end

scene "option_a" do
  color :bg, :orange, :darker
  color :text, :black
  label RUBY_VERSION, 4, 4
  wait 30
  goto "main"
end

scene "option_b" do
  color :bg, :blue, :lighter
  main_loop <<-EOH
    player.y+=2 if is_pressed(:k)
    player.y-=2 if is_pressed(:j)
    sprite "player"
    blocker.x=rand(70)
    blocker.y=rand(30)
    sprite "blocker"
    enemy.x = 69
    enemy.y = rand(30)
    sprite "enemy"
    if shoot_flag==1 then
      shoot.x=shoot.x+4
      if shoot.x>72 then
        shoot_flag=0
      end
    elsif shoot_flag==0 && is_pressed(:a) then
      shoot.y=player.y+1
      shoot.x=1
      shoot_flag=1
    end
    sprite "shoot"
    if shoot.x+1 > enemy.x-2 && shoot.y <=enemy.y && shoot.y >= enemy.y-3 then
      goto "clear"
    end
  EOH
end

scene "clear" do
  color :bg, :red
  color :text, :white
  label "YOU WIN!!!!"
  wait 50
  goto "main"
end