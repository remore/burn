# Burn - a handy toolkit to homebrew 8-bit flavored applications from Ruby DSLs

A .nes application below is compiled in less than 500 lines of Ruby DSL code, including graphic and sound resources.([code](https://github.com/remore/burn/blob/master/example/rubima_wars/main.rb) / [online demo](http://k.swd.cc/burn/resource/example/rubima-wars/emulator.html))

![rubima wars pic](http://k.swd.cc/burn/resource/screenshot/rubima-wars.png)

Next example is about cross-compilation. Assuming you write this simple Ruby DSL:

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

With Burn, you can compile this to .nes:

![star animated gif](http://k.swd.cc/burn/resource/screenshot/star.gif)

and at the same time, you can run this as a telnet server application:

![star animated telnet server app](http://k.swd.cc/burn/resource/screenshot/star-telnet.gif)

Just like Recipe and Cookbook are DSLs for the Chef rubygem, this dead simple DSL is for the Burn rubygem, and we call it Fuel. 

Imagine 8-bit application like [ascii starwars movie](http://lifehacker.com/373571/watch-star-wars-in-text-via-telnet) can be created in seconds, seriously. Now is the time to go back and start to develop primitive, low-end application.

![system menu example](http://k.swd.cc/burn/resource/screenshot/system-menu.gif)

## Table Of Contents

* [Introduction](#introduction)
    * [Why Burn](#why-burn)
    * [How It Works](#how-it-works)
    * [Requirements](#requirements)
* [Getting Started](#getting-started)
    * [Installation](#installation)
    * [Quick Start](#quick-start)
* [Fuel DSL](#fuel-dsl-methods)
* [Notes](#notes)
    * [Helpful Folks](#helpful-folks)
    * [License](#license)
    * [ToDos](#todos)

## Introduction

### How It Works

Burn have two modes, `:rom` mode nad `:telnet` mode.

For `:rom` mode, Burn uses cc65 executables embedded in its gemfile for compilation. The main workflow is as follows.

- translate ruby DSL file into c source code
- compile them to make executable(*.nes) by calling cc65
- provide an emulator(JSNES) for rapid application development

Meanwhile, for `:telnet` mode Burn works like this:

- translate ruby DSL file into CRuby source code
- provide telnet server function to run the code on burn VM

### Requirements

- Ruby1.9.1+
- gcc (Winows users do not require this)

Burn supports all major OS like MacOS, Unix-like systems and Windows.

## Getting Started

### Installation

    sudo gem install burn
    sudo burn init

### Quick Start

    # :nes mode
    echo "scene {label 'hello world'}" > main.rb
    burn # make .nes rom and launch .nes emulator
    ls tmp/burn/ | grep main.nes
    
    # :telnet mode
    echo -e "config(:app){ target :telnet }\nscene {label 'hello world'}" > main.rb
    burn & # run telnet server
    telnet localhost 60000

More Examples are available at example folder. kindly try to `git clone https://github.com/remore/burn.git` and play.

## Fuel DSL

Currently example code are definitely the best reference. As to documentation, please see following materials:

[Reference for :nes mode](https://github.com/remore/burn/blob/master/FUEL-ROM.md)

Reference for :nes mode(coming soon)

...and there is many TBDs(articles about #show, #sprite, #rand and #is_pressed are coming very soon)

## Notes

### Why Burn

Primarily, to let anti-piracy movement gain significant momentum. There are [countless ways out there](http://en.wikipedia.org/wiki/List_of_video_game_emulators#Consoles) that emulate .nes game, but very few that create .nes rom file without hassle. This is the original reason why @remore have developed Burn.

Secondarily, to get back a lost love to video game programming. Having high-spec machine is not always happy to us, human beings. Sometimes we'd better to look back the old era where many constrains still exist. You might think it's silly, but I'm serious. It's crazy fun to struggle.

### Discussions and Conference Talks

A quick discussion at [Reddit.com](http://www.reddit.com/r/programming/comments/226vf0/build_your_own_nes_rom_file_with_ruby/)

[A Talk at RubyKaigi 2014](http://rubykaigi.org/2014/presentation/S-KeiSawada)

[Introduction at rubima(Rubyist Magazine)](http://magazine.rubyist.net/?0047-IntroductionToBurn)

### Helpful Folks

* Shiru - This project had never been born if I had not found [this article](http://shiru.untergrund.net/articles/programming_nes_games_in_c.htm)
* My friend from high school - I appreciate him for sending me fine-grained reviews as always
* @josbrahol sent me a great pull request which contains many grammatical errors
* @kdb424 sent me a pull request to fix a typo

### License

GPLv3

### ToDos

Here are a few todo-memo for :nes mode.

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
    * make Burn rubygem work with mruby(not soon)
* Fix bugs
    * declaring 2x2 pattern works, however 2x1 pattern doesn't
