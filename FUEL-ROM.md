# Fuel DSL for :rom mode

Currently the following four resources are available for :rom mode.(:telnet mode reference will be prepared soon)

Let's take a quick look how we can make an 8-bit flavored application without hassle!

* [Scene](#scene)
* [Sound](#sound)
* [Music](#music)
* [Declare](#declare)

### Scene

Scene resource is a key concept to make any kind of application. This is where you design screen transition, controller event binding and game balance design etc etc..

#### label(string, x=0, y=1)

The label method can be used in a scene to display a static string.

<dl>
  <dt>string String</dt>
  <dd>Static string to display.</dd>
  <dt>x Number</dt>
  <dd>The horizontal coordinate to display, between 0 and 31.</dd>
  <dt>y Number</dt>
  <dd>The vertical coordinate to display, between 0 and 28.</dd>
</dl>

```ruby
scene do
  label "Hello, World!"
  label "Hello, World!", 4, 5
end
```

![label pic](http://k.swd.cc/burn/resource/screenshot/label.png)

#### fade_in, fade_out

These methods can be used in a scene to fade in or out.

```ruby
scene do
  label "Hello"
  fade_in
  main_loop
  fade_out
  goto "next"
end
```

#### play(song_title)

The play method can be used in a scene to play music.

<dl>
  <dt>song_title String</dt>
  <dd>Song title to play.</dd>
</dl>

```ruby
scene do
  play "battle"
  stop
end

music "battle" do
  channel "string" do
    g   :dotted
    g   :eighth
    c   :half
  end
end
```

#### stop

The stop method can be used in a scene to stop music.

```ruby
scene do
  stop "battle"
end
```

#### color(palette, color, lightness=:lighter)

The color method can be used in a scene to pick a color and set it to specific palette.

<dl>
  <dt>palette Symbol</dt>
  <dd>Palette to set.
    <table>
      <tr>
        <th>Palette Symbol</th>
        <th>Description</th>
      </tr>
      <tr>
        <td>:bg</td>
        <td>Background color</td>
      </tr>
      <tr>
        <td>:text</td>
        <td>Foreground color</td>
      </tr>
      <tr>
        <td>:palette_x1, :palette_x2, :palette_x3</td>
        <td>Colors for :palette_x</td>
      </tr>
      <tr>
        <td>:palette_y1, :palette_y2, :palette_y3</td>
        <td>Colors for :palette_y</td>
      </tr>
      <tr>
        <td>:palette_z1, :palette_z2, :palette_z3</td>
        <td>Colors for :palette_z</td>
      </tr>
      <tr>
        <td>:sprite</td>
        <td>Sprite color</td>
      </tr>
    </table>
  </dd>
  <dt>color Symbol</dt>
  <dd>Color to set. Available color pattern is shown below.<br />
    <img src="http://www.thealmightyguru.com/Games/Hacking/Wiki/images/e/e8/Palette_NTSC.png">
    <table>
      <tr>
        <th>Color Symbol</th>
      </tr>
      <tr><td>:white</td></tr>
      <tr><td>:lightblue</td></tr>
      <tr><td>:blue</td></tr>
      <tr><td>:purple</td></tr>
      <tr><td>:pink</td></tr>
      <tr><td>:red</td></tr>
      <tr><td>:deepred</td></tr>
      <tr><td>:orange</td></tr>
      <tr><td>:lightorange</td></tr>
      <tr><td>:darkgreen</td></tr>
      <tr><td>:green</td></tr>
      <tr><td>:lightgreen</td></tr>
      <tr><td>:bluegreen</td></tr>
      <tr><td>:gray</td></tr>
      <tr><td>:black</td></tr>
    </table>
  </dd>
  <dt>lightness Symbol</dt>
  <dd>Lightness of the color to set. `:darkest`, `:darker`, `:lighter` and `:lightest` can be set.</dd>
</dl>

```ruby
scene do
  label "Hello, World!"
  color :text, :green, :lighter
end
```

![color pic](http://k.swd.cc/burn/resource/screenshot/color.png)

#### wait(interval)

The wait method can be used in a scene to pause for a certain period of time.

<dl>
  <dt>interval Fixnum</dt>
  <dd>Period of time to pause.</dd>
</dl>


```ruby
scene do
  label "foobar"
  fade_out
  wait 100
  goto "somewhere"
end
```

#### goto(scene_name)

The goto method can be used in a scene to jump to the scene specified.

<dl>
  <dt>scene_name String</dt>
  <dd>Jump destination.</dd>
</dl>

```ruby
scene "first" do
  label "good morning"
  goto "second"
end

scene "second" do
  label "hi there"
end
```

#### inline(code)

The inline method can be used in a scene to manually inject C source code to compile with cc65 (should be used for debugging purposes).

<dl>
  <dt>code String</dt>
  <dd>C code to inject.</dd>
</dl>

```ruby
scene do
  inline "x=1+2;"
end
```

#### screen(map, vars)

The screen method can be used to inflate map data to a scene.

<dl>
  <dt>map String</dt>
  <dd>Map data consists of hash keys of pattern design.</dd>
  <dt>vars Hash</dt>
  <dd>A list of pattern designs.</dd>
</dl>

```ruby
scene do
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
end
```

#### sound(effect_name)

The sound method in a scene can be used to play sound effects.

<dl>
  <dt>effect_name String</dt>
  <dd>Name of sound effect to play.</dd>
</dl>

```ruby
scene do
  sound "dead"
end

sound "dead" do
  effect do
    velocity 15
    length 5
    pitch 200
  end
end
```

#### paint(dest, palette)

The paint method in a scene can be used to associate a color palette with pattern designs inflated on the screen. Typically #paint is called along with #color and #screen method.

<dl>
  <dt>dest Range</dt>
  <dd>Return value of #range(x_from, y_from, x_to, y_to) is expected. x_from and x_to takes the number between 0 and 255 while y_from and y_to takes the value between 0 and 239.</dd>
  <dt>palette Symbol</dt>
  <dd>Palette symbol to apply. Kindly refer to the candidate symbols listed at <a href="#colorpalette-color-lightnesslighter">color</a> section.</dd>
</dl>

```ruby
scene "title" do
  color :palette_x1, :deepred, :darker
  paint range("44px", "5px", "120px", "3px"), :palette_x # range takes String parameter

  color :palette_y2, :pink, :darkest
  paint range(30, 2, 30, 12), :palette_y # range method can take Number as well. In this case x_from and x_to takes the value between 0 and 31, while y_from and y_to takes the value from 0 and 29.
end
```

#### main_loop(rrb_source=nil)

The main_loop method in a scene can be used to repeat a block of code. More detail can be found at [.rrb section](#programming-with-rrbrestricted-ruby-syntax).

<dl>
  <dt>rrb_source String</dt>
  <dd>Source code written in .rrb(Resticted Ruby) syntax.</dd>
</dl>

```ruby
scene "title" do
  color :palette_x1, :deepred, :darker
  paint range("44px", "5px", "120px", "3px"), :palette_x # range takes String parameter

  color :palette_y2, :pink, :darkest
  paint range(30, 2, 30, 12), :palette_y # range method can take Number as well. In this case x_from and x_to takes the value between 0 and 31, while y_from and y_to takes the value from 0 and 29.
end
```

### Declare

Declare resource is an essential part of programming with using Scene#main_loop.

If you give Number as shown below, then a method name like #frame or #color_flag, it becomes variable in Scene#main_loop process.

```ruby
declare do
  frame 0
  color_flag 0
end
```

If you give String constants as 8x8 character blocks, like the following example code, then the left-hand member becomes a sprite object in the Scene#main_loop process.

```ruby
declare do
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
end
```

### Music

This is where the Burn rubygem composes music for you. The only requirement for you to start to compose music is your favorite text editor.

Music resource can accept only two methods so far, #tempo and #channel.

#### tempo(speed)

The tempo method in music can be used to set the tempo of a song.

<dl>
  <dt>speed Symbol</dt>
  <dd>song speed symbol to set.
    <table>
      <tr>
        <th>Song Speed</th>
      </tr>
      <tr><td>:presto</td></tr>
      <tr><td>:allegro</td></tr>
      <tr><td>:moderato</td></tr>
      <tr><td>:andante</td></tr>
      <tr><td>:adagio</td></tr>
      <tr><td>:largo</td></tr>
    </table>
  </dd>
</dl>

```ruby
music "fanfare" do
  tempo :allegro
  channel ...
end
```

#### channel(instrument)

The channel method in music can be used to set a channel of the song. Maximum of three channels per music can be set.

<dl>
  <dt>instrument String</dt>
  <dd>instrument to play.
    <table>
      <tr>
        <th>Instrument</th>
      </tr>
      <tr><td>"bass"</td></tr>
      <tr><td>"piano"</td></tr>
      <tr><td>"string"</td></tr>
      <tr><td>"arpeggio"</td></tr>
      <tr><td>"step"</td></tr>
      <tr><td>"bell"</td></tr>
      <tr><td>"acoustic"</td></tr>
      <tr><td>"guitar"</td></tr>
      <tr><td>"theremin"</td></tr>
    </table>
  </dd>
</dl>

Notes of the music are described as shown below.

- Total 61 notes(5 octaves + rest) notes are available.
    - For instance, available methods are, `#c0`(0 stands for octave), `#ds0`(s stands for flat), `#d0`, `#es0`...
- `#segno` and `#dal_segno` are available too
    - This way you can repeat a song
- Each note can take length as their parameter. Here is list of length available
    - `:sixteenth`, `:eighth`, `:quarter`, `:half`
    - `:dotted_sixteenth`, `:dotted_eighth`, `:dotted_quarter`, `:dotted_half`
    - `:triplet_sixteenth`, `:triplet_eighth`, `:triplet_quarter`, `:triplet_half`
- Each note can take an expression parameter as well
    - `:tenuto`
    - `:accent`
    - `:staccato`

Understanding the above will allow you to easily make music. Here is some example music.

```ruby
music "sarabande" do
  tempo :allegro
  channel "string" do
    segno
    d2   :eighth
    rest :eighth
    e2   :eighth
    rest :eighth
    dal_segno
  end
  channel "piano" do
    segno
    a3   :dotted_eighth
    rest :sixteenth
    g3   :triplet_eighth
    g3   :triplet_eighth
    g3   :triplet_eighth
    dal_segno
  end
end
```

### Sound

Sound resource can only accept the #effect method as of now. Available methods for #effect are shown below.

#### effect

with this block, you can call the following method to configure sound settings.

####

The duty_cycle method in a sound can be used to set the duty cycle type.

<dl>
  <dt>duty_cycle(ratio)</dt>
  <dd>duty cycle symbol to set. It takes :higher by default.
    <table>
      <tr>
        <th>Duty Cycle Type</th>
        <th>Value</th>
      </tr>
      <tr>
        <td>:lowest</td>
        <td>12.5%</td>
      </tr>
      <tr>
        <td>:lower</td>
        <td>25%</td>
      </tr>
      <tr>
        <td>:higher</td>
        <td>50%</td>
      </tr>
      <tr>
        <td>:highest</td>
        <td>75%</td>
      </tr>
    </table>
  </dd>
  <dt>velocity(level)</dt>
  <dd>Volume level number of the sound, between 0 and 15. It takes 7 by default.</dd>
  <dt>envelope_decay(flag), envelope_decay_loop(flag), length_counter_clock(flag)</dt>
  <dd>It takes either :enable or :disable flag symbol. Disabled by default.</dd>
  <dt>length(size)</dt>
  <dd>Length number of the sound effect, between 1 and 254. It takes 16 by default.</dd>
  <dt>pitch(control)</dt>
  <dd>Control number of the sound effect, between 0 and 254. (This value is stil uncontrollable so far. Need to improve)</dd>
</dl>

```ruby
sound "attack" do
  effect do
    duty_cycle
    velocity 15
    envelope_decay :disable
    length 10
    pitch 200
    envelope_decay_loop :disable
    length_counter_clock :disable
  end
end
```

## Burning Fuel DSL In Action

### Programming With .rrb(Restricted Ruby) Syntax

- Afterimage of each sprite can be removed by adding `inline "oam_clear();"` statement at the top of .rrb program source(at the top line of source text for `main_loop`), as discussed in [issue #20](https://github.com/remore/burn/issues/20#issuecomment-245478929)
- more details are TBD(articles about #show, #sprite, #rand and #is_pressed are coming very soon)
