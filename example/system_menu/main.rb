config :app do
  terminal :telnet
  user_input :enable
end

declare do
  frame 0
end

scene do
  color :bg, :blue, :darker
  color :text, :white
  label "What would you like to do?", 2, 2
  label "Type key code from A to C (use big letters pls)", 2, 3
  label "----------------", 2, 4

  label "(a) Show the version of ruby of this system", 2, 6
  
  label "(B) (*nix user only) Eject a default device", 2, 10
  
  main_loop <<-EOH
    if is_pressed(:a) then
      goto "option_a"
    end
    if is_pressed(:B) then
      goto "option_b"
    end
  EOH
end


scene "option_a" do
  label RUBY_VERSION, 4, 4
end

scene "option_b" do
  main_loop <<-EOH
    if frame==0 then
      system "eject"
      frame=1
    end
  EOH
end
