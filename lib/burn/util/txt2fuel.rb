module Burn
  module Util
    class Txt2Fuel
      attr_reader :width, :height, :separator, :rabbit_timer

      def initialize(width=73, height=10, separator="^ *#", rabbit_timer=0)
        @width = width
        @height = height
        @separator = separator
        @rabbit_timer = rabbit_timer
      end

      def convert(textfile)
        pages = []
        pages.push []
        textfile.encode!('UTF-8')
        textfile.each_line do |line|
          pages.push [] if line.match(Regexp.new(@separator)) && pages[pages.count-1].count>0
          if line =~ /(?:\p{Hiragana}|\p{Katakana}|[一-龠々])/ then # if Multibyte character is contained
            formatted_text = line.chomp.chars.each_slice((@width-2)/2).map{|a| a.join}
          else
            formatted_text = line.chomp.scan(/.{,#{@width-2}}/)
          end
          formatted_text.each do |words|
            if words.length>0 || line==10.chr then
              pages[pages.count-1].push words
            end
            if pages[pages.count-1].count >= @height-2 then
              pages.push []
            end
          end
        end

        fuel = "
  config :app do
    target :telnet
    user_input :enable
    frame_rate :extreme
    height #{@height}
    width #{@width}
  end

  config :server do
    ip_addr '0.0.0.0'
    max_clients 1000
  end
  "
        pages.each_with_index do |page, i|
          fuel += ""
          fuel +=  "scene 'page_#{i}' do\n"
          page.each_with_index do |line, index|
            fuel +=  "  label '#{line.gsub("'", "\\\\'")}', 1, #{index}\n"
          end
          page_info_width = ("/"+(pages.count*2).to_s).length-1
          fuel +=  "  label '#{i+1}/#{pages.count}', #{@width-page_info_width-1}, #{@height-1}\n"
          if @rabbit_timer>0 then
            fuel +=  "  label '|' + ('-'*#{@width-page_info_width-4}).to_s + '|', 1, #{@height-1}\n"
            fuel +=  "  label '@', #{((@width-page_info_width-2)*((i+1).to_f/pages.count.to_f)).to_i}, #{@height-1}\n"
          end
          fuel +=  "  main_loop <<-EOH\n"
          if @rabbit_timer>0 then
            fuel +=  %[    inline "self.screen.display[#{@height-1}][(#{@width-page_info_width-1}*(Time.now.to_i - self.time).to_f/#{@rabbit_timer}.to_f).to_i < #{@width-page_info_width-1} ? (#{@width-page_info_width-1}*(Time.now.to_i - self.time).to_f/#{@rabbit_timer}.to_f).to_i + 2 : #{@width-page_info_width-1},1] = '>'"\n]
          else
            fuel +=  %[    inline "self.screen.display[#{@height-1}][1,5] = Time.at(Time.now.to_i - self.time).strftime('%M:%S')"\n]
          end
          fuel +=  %[    goto "page_#{i+1==pages.count ? 0 : i+1}" if is_pressed(10.chr)\n]
          fuel +=  %[    goto "page_#{i+1==pages.count ? 0 : i+1}" if is_pressed(13.chr)\n]
          fuel +=  %[    goto "page_#{i+1==pages.count ? 0 : i+1}" if is_pressed(:f)\n]
          fuel +=  %[    goto "page_#{i-1<0 ? pages.count-1 : i-1}" if is_pressed(:b)\n]
          fuel +=  "  EOH\n"
          fuel +=  "end\n"
        end
        fuel
      end
    end
  end
end
