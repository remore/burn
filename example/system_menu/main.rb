config :app do
  terminal :telnet
  user_input :enable
  width 73
  height 13
end

scene "main" do
  label "Action?", 2, 2
  label "Type one of following key codes:", 2, 3
  label "--------------", 2, 4

  label "(a) Show the version of ruby of this system", 2, 6
  
  label "(b) (*nix user only) Eject a default device", 2, 10
  
  label "(c) Show current time", 2, 12
  
  main_loop <<-EOH
    if is_pressed(:a) then
      goto "option_a"
    end
    if is_pressed(:b) then
      goto "option_b"
    end
    if is_pressed(:c) then
      goto "option_c"
    end
  EOH
end

scene "option_a" do
  color :bg, :blue, :darker
  label RUBY_VERSION, 4, 4
  wait 10
  goto "main"
end

scene "option_b" do
  color :bg, :green, :darker
  label "now ejecting disc...", 4, 4
  system "eject"
  wait 10
  goto "main"
end

scene "option_c" do
  system "ruby -e 'puts Time.new'"
  wait 10
  goto "main"
end
