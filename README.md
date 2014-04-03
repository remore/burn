# Burn - a handy toolkit to make .nes application from Ruby DSL

Burn is a free and open source framework that allows you to create 8-bit flavored application(.nes) using Ruby DSL.

```ruby
scene do
  label "Hello, World!"
end
```

Just like Recipe and Cookbook are DSL for Chef rubygem, this dead simple DSL is for Burn rubygem, and we call it Fuel. Burning this Fuel will produce [this](http://k.swd.cc/burn/resource/example/hello-world/emulator.html).

![Hello-world pic](http://k.swd.cc/burn/resource/screenshot/hello-world.png)

Here is another example. With Fuel DSL, you can even compose background music in seconds.

```ruby
scene do
  label "Hello, World!"
  play "openning"
end

music "openning" do
  tempo :allegro
  channel "piano" do
    segno
    g :dotted
    g :eighth, :staccato
    a :dotted
    a :eighth, :staccato
    dal_segno
  end
end
```

Check [the output](http://k.swd.cc/burn/resource/example/hello-world-with-music/emulator.html) from this. 

Would you like to design retro 8-bit graphics? Here you go.

```ruby
declare do
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
end

scene do
  main_loop <<-EOH
    star.x=20
    star.y-=3
    sprite "star"
EOH
end

```

![star animated gif](http://k.swd.cc/burn/resource/screenshot/star.gif)

Please visit [our project page](http://k.swd.cc/burn/) for more example.

## Table Of Contents

* [Introduction](#introduction)
    * [Less Is More](#less-is-more)
    * [How It Works](#how-it-works)
* [Getting Started](#getting-started)
    * [Installation](#installation)
    * [Quick Start](#quick-start)
    * [Burning Sample Fuel DSL](#burning-sample-fuel-dsl)
* [Fuel DSL Methods](#fuel-dsl-methods)
    * [Scene](#scene)
    * [Sound](#sound)
    * [Music](#music)
    * [Declare](#declare)
* [Burning Fuel DSL In Action](#burning-fuel-dsl-in-action)
    * [Programming With .rrb(Restricted Ruby) Syntax](#programming-with-rrbrestricted-ruby-syntax)
* [Notes](#notes)
    * [Personal Motivation](#personal-motivation)
    * [Helpful Folks](#helpful-folks)
    * [License](#license)
    * [ToDos](#todos)

## Introduction

### Less Is More

Creating 8-bit flavored application mean neither outdated nor cheap, but good fit to rapid prototyping. It could be one of best options for education purpose as well.

Moreover, the executables built with burn will work at [almost any OS](http://en.wikipedia.org/wiki/List_of_video_game_emulators#Consoles). That said, consequently, burn is a multi-platform programming environment.

### How It Works

Internally, burn contains cc65 executables inside its gemfile and calls them to compile. Main workflow is as follows.

- translate ruby DSL file into c source code
- compile them to make executable(*.nes) by calling cc65
- provide emulator(JSNES) for rpaid application development

### Requirements

- Ruby1.9.1+
- gcc(for windows user this is not required)

## Getting Started

### Installation

    sudo gem install burn
    sudo burn init --make

### Quick Start

`burn -p` command use Firefox primarily. If you'd like to use chrome, type `burn -p -c` instead.

    echo "scene {label 'hello world'}" > main.rb
    burn -p
    ls tmp/burn/ | grep main.nes

### More Examples

Customize example/shooting/main.rb and play with it if you please.

    git clone https://github.com/remore/burn.git
    cd burn/example/shooting
    burn -p -c
     
    # if you'd like to make executable, simply remove -p option or type burn make
    burn
    burn make
     
    # you can boot the emulator up whenever you want(without burning Fuel DSL)
    burn play

## Fuel DSL Methods

Currently following DSL Methods are available. If you are newbie here, kindly visit [project page](http://k.swd.cc/burn/) first to see what you can do with Burn and Fuel DSL.

* [Scene](#scene)
* [Sound](#sound)
* [Music](#music)
* [Declare](#declare)

### Scene

#### label(string, x=0, y=1)

The label method can be used in a scene to display static string.

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
  color :text, :pink, :darker
end
```

#### wait(interval)

The wait method can be used in a scene to pause for certain period of time.

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

The goto method can be used in a scene to jump the scene specified.

<dl>
  <dt>scene_name String</dt>
  <dd>Destination to jump.</dd>
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

The inline method can be used in a scene to inject c source code manually to compile with cc65. Should be used for debugging purpose.

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

The sound method in a scene can be used to play sound effect.

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

The paint method in a scene can be used to associate color palette with pattern designs inflated on the screen. Typically #paint is called along with #color and #screen method.

<dl>
  <dt>dest Range</dt>
  <dd>Return value of #range(x_from, y_from, x_to, y_to) is expected. x_from and x_to takes the number between 0 and 255 while y_from and y_to takes the value between 0 and 239.</dd>
  <dt>palette Symbol</dt>
  <dd>Palette symbol to apply. Kindly refer candidate symbols listed at <a href="#colorpalette-color-lightnesslighter">color</a> section.</dd>
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

### Sound

#### duty_cycle(ratio)

The duty_cycle method in a sound can be used to set duty cycle type.

<dl>
  <dt>ratio Symbol</dt>
  <dd>duty cycle symbol to set. It takes :higher by default.
    <table>
      <tr>
        <th>duty cycle type</th>
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
</dl>

```ruby
sound "attack" do
  effect do
    duty_cycle :higher
  end
end
```

#### velocity(level)

The velocity method in a sound can be used to set volume level of the sound.

<dl>
  <dt>level Number</dt>
  <dd>Volume level of the sound, between 0 and 15. It takes 7 by default.</dd>
</dl>

```ruby
sound "attack" do
  effect do
    velocity 12
  end
end
```

#### envelope_decay(flag), envelope_decay_loop(flag), length_counter_clock(flag)

The envelope_decay/envelope_decay_loop/length_counter_clock method in a sound can be used to switch their setting.

<dl>
  <dt>flag Symbol</dt>
  <dd>It takes either :enable or :disable symbol. Disabled by default.</dd>
</dl>

```ruby
sound "attack" do
  effect do
    envelope_decay :enable
    envelope_decay_loop :disable
    length_counter_clock :disable
  end
end
```

#### length(size)

The length method in a sound can be used to set length of the sound effect.

<dl>
  <dt>size Number</dt>
  <dd>Length of the sound effect, between 1 and 254. It takes 16 by default.</dd>
</dl>

```ruby
sound "attack" do
  effect do
    length 22
  end
end
```

#### pitch(control)

The pitch method in a sound can be used to control pitch of the sound effect.

<dl>
  <dt>control Number</dt>
  <dd>Control of the sound effect, between 0 and 254. (This value is stil uncontrollable so far. Need to improve)</dd>
</dl>

```ruby
sound "attack" do
  effect do
    pitch 100
  end
end
```

### Music

TBD

### Declare

TBD

## Burning Fuel DSL In Action

### Programming With .rrb(Restricted Ruby) Syntax

TBD(articles about #show, #sprite, #rand and #is_pressed are coming very soon)

## Notes

### Helpful Folks

* Shiru - this project had never been born if I had not found [this article](http://shiru.untergrund.net/articles/programming_nes_games_in_c.htm)
* My friend from high school - I appreciate him for sending me fine-grained review as always

### License

GPLv3

### ToDos

* New VM Support
    * compatiblize with enchant.js
* Enhancement of Fuel DSL
    * for Screen, support screen scroll and simple sprite
    * for Screen, adding .bmp and .png support to make designing pattern table easier
    * for Sound, add triangle wave and noise effect
    * for Music, add custom instrument DSL
    * for Declare, support string and boolean declaration(currently only number and pattern table is supported)
* Improvement of Internal Architecture
    * make cc65 alternative in Ruby
* Other Feature To Be Supported
    * make burn rubygem work with mruby(not soon)
* Fix bugs
    * declaring 2x2 pattern works, however 2x1 pattern doesn't
