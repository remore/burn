config :app do
  terminal :telnet
end

declare do
  foo <<-EOH
@
@@
@@@
EOH
end

scene do
  main_loop <<-EOH
    foo.x=20
    foo.y-=1
    sprite "foo"
    wait 10
EOH
end
