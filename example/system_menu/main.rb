config :app do
  target :telnet
  user_input :enable
  width 73
  height 13
end

scene "main" do
  label "Action?", 2, 2
  label "Type one of following key codes:", 2, 3
  label "--------------", 2, 4

  label "(a) Show the version of ruby of this system", 2, 6
  
  label "(b) (*nix user only) Eject a default device", 2, 8
  
  main_loop <<-EOH
    goto "option_a" if is_pressed(:a)
    goto "option_b" if is_pressed(:b)
  EOH
end

scene "option_a" do
  color :bg, :blue, :darker
  label RUBY_VERSION, 4, 4
  wait 30
  goto "main"
end

scene "option_b" do
  color :bg, :green, :lighter
  label "now ejecting disc...", 4, 4
  system "eject"
  wait 30
  goto "main"
end
