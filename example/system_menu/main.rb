config :app do
  terminal :telnet
  user_input :enable
  width 73
  height 13
end

declare do
  frame 0
end

scene do
  label "Action?", 2, 2
  label "Type one of following key codes:", 2, 3
  label "--------------", 2, 4

  label "(a) Show the version of ruby of this system", 2, 6
  
  label "(b) (*nix user only) Eject a default device", 2, 10
  
  main_loop <<-EOH
    if is_pressed(:a) then
      goto "option_a"
    end
    if is_pressed(:b) then
      goto "option_b"
    end
  EOH
end


scene "option_a" do
  color :bg, :blue, :darker
  color :text, :white
  label RUBY_VERSION, 4, 4
end

scene "option_b" do
  color :bg, :green, :darker
  color :text, :red
  main_loop <<-EOH
    if frame==0 then
      system "eject"
      frame=1
    end
  EOH
end
