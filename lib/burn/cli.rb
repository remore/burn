module Burn
  class BurnTasks < Thor
    include Thor::Actions
    
    def initialize(*args)
      super
      @workspace_root = Dir.getwd
    end
    
    def self.source_root
      File.dirname(__FILE__) + "/.."
    end
    
    default_task :make
    
    desc "init", "Initialize environment"
    option :debug, :type => :string, :aliases => '-d', :desc => "Debug mode"
    option :verbose, :type => :boolean, :desc => "Print logs as much as possible", :default => false
    option :quick, :type=>:boolean, :desc=>"Make cc65 binaries available without gcc(however unstable. This option is not recommended.)"
    def init
      env = Burn::Util::Os.new
      base_path = "#{File.dirname(__FILE__)}/tools"
      remove_dir base_path+ "/"+env.os_name, :verbose => options[:verbose]
      Burn::Util::Unpack.new.unpack "#{base_path}/#{env.os_name}.tar.gz", base_path
      if !env.is_win? && !options[:quick] then
        Burn::Util::Unpack.new.unpack "#{base_path}/src.tar.gz", base_path
        run "/bin/bash #{File.dirname(__FILE__)}/tools/make_exec.sh #{base_path}"
        copy_file "#{base_path}/src/cc65/cc65", "#{base_path}/#{env.os_name}/cc65/bin/cc65", :force => true
        copy_file "#{base_path}/src/ca65/ca65", "#{base_path}/#{env.os_name}/cc65/bin/ca65", :force => true
        copy_file "#{base_path}/src/ld65/ld65", "#{base_path}/#{env.os_name}/cc65/bin/ld65", :force => true
      end
      say "successfully finished. now you are ready to burn."
    end

    desc "make <filename>", "Compile and build application binary from Burn DSL file"
    option :preview, :type => :boolean, :aliases => '-p', :desc => "Preview .out application right after compilation"
    option :debug, :type => :string, :aliases => '-d', :desc => "Debug mode"
    option :verbose, :type => :boolean, :desc => "Print logs as much as possible", :default => false
    option :chrome, :type => :boolean, :aliases => '-c',  :desc => "Run emulator on chrome instead of firefox", :default => false
    def make(mainfile=nil)
      env = Burn::Util::Os.new
      mainfile="main.rb" if mainfile.nil?
      
      if !File.exist?(mainfile) then
        help
      
      elsif !File.exist?("#{File.dirname(__FILE__)}/tools/#{env.os_name}/cc65/bin/ld65") then
        say "error: you are not ready to burn, most probably you haven't initialized yet."
        say "to fix this, try the following command:"
        say ""
        say "    burn init"
        say "    (try 'sudo burn init' if you don't have enough permission to change gems folder of your local system)"
        say ""
      
      else
        
        # used a icon from noun project. Thanks Jenny!
        # http://thenounproject.com/term/fire/24187/
        say <<-EOS
                                                                
             `.::-`                                             
             :hNMMNNds/.                                        
               :dMMMMMMNdo.                                     
                `oNMMMMMMMNh:                                   
                  /NMMMMMMMMNy.                                 
                   +MMMMMMMMMMm/                                
                    dMMMMMMMMMMNo                               
                    oMMMMMMMMMMMM+                              
                    +MMMMMMMMMMMMN/                             
                    sMMMMMMMMMMMMMm.                            
                   `mMMMMMMMMMMMMMMs        ::`                 
                   /MMMMMMMMMMMMMMMN.       `hh/`               
                  `dMMMMMMMMMMMMMMMMo        -NMd/`             
                  sMMMMMMMMMMMMMMMMMd         yMMMh-            
                 /MMMMMMMMMMMMMMMMMMN.        /MMMMN+           
                :NMMMMMMMMMMMMMMMMMMM-        :MMMMMMo`         
               -mMMMMMMMMMMMMMMMMMMMM/        oMMMMMMMo         
              .dMMMMMMMMMMMMMMMMMMMMMo       .mMMMMMMMN:        
             .dMMMMMMMMMMMMMMMMMMMMMMm`     .dMMMMMMMMMm`       
            `dMMMMMMMMMMMMMMMMMMMMMMMMy.```/mMMMMMMMMMMMo       
           `hMMMMMMMMMMMMMMMNNNMMMMMMMMNhhmMMMMMMMMMMMMMm`      
          `hMMMMMMMMMMMMMMMN/`-/yNMMMMMMMMMMMMMMMMMMMMMMM:      
         `yMMMMMMMMMMMMMMMMMN-   .hMMMMMMMMMMMMMMMMMMMMMMy      
         sMMMMMMMMMMMMMMMMMMMy     sMMMMMMMMMMMMMMMMMMMMMd      
        +MMMMMMMMMMMMMMMMMMMMd     `hMMMMMMMMMMMMMMMMMMMMN`     
       -NMMMMMMMMMMMMMMMMMMMMs      .NMMMMMMMMMMMMMMMMMMMM-     
      `dMMMMMMMMMMMMMMMMMMMMm.       sMMMMMMMMMMMMMMMMMMMM:     
      +MMMMMMMMMMMMMMMMMMMMN-        -MMMMMMMMMMMMMMMMMMMM.     
     `mMMMMMMMMMMMMMMMMMMMm-          NMMMN+NMMMMMMMMMMMMN      
     /MMMMMMMMMMMMMMMMMMMh.           NMMMM--mMMMMMMMMMMMh      
     yMMMMMMMMMMMMMMMMMN+`           .MMMMM+ -mMMMMMMMMMM+      
    `mMMMMMMMMMMMMMMMMh-             +MMMMM:  /MMMMMMMMMN.      
    -MMMMMMMMMMMMMMMN+`              yMMMMs    hMMMMMMMMy       
    :MMMMMMMMMMMMMMd-                :hhy:`    /MMMMMMMN.       
    .NMMMMMMMMMMMMy.                  ``       -MMMMMMMo        
     dMMMMMMMMMMMs`                            .MMMMMMd`        
     +MMMMMMMMMMy`                             :MMMMMN-         
     `dMMMMMMMMN.                              sMMMMN/          
      :NMMMMMMMh                              `mMMMN+           
       +MMMMMMMs            burn              oMMMN+            
        +NMMMMMh                             -NMMm:             
         /mMMMMN-          v#{VERSION}           .dMNy.              
          .hNMMMh`                         .dNh:                
           `/mMMMh.                       -hy:`                 
             `+mMMm/`                   `:+.                    
               `/hNMd+.                 ``                      
                  .+hNNy/.                                      
                     `-/oo:                                     
                                                                
                                                                
EOS
        # init
        say "."
        remove_dir "#{@workspace_root}/tmp/burn", :verbose => options[:verbose]
        empty_directory "#{@workspace_root}/tmp/burn", :verbose => options[:verbose]
        #directory File.dirname(__FILE__) + "/workspace_default", "#{@workspace_root}/tmp/burn", :verbose => options[:verbose]
        Burn::Util::Unpack.new.unpack "#{File.dirname(__FILE__)}/tools/workspace_default.tar.gz", "#{@workspace_root}/tmp/burn"
        
        # compile and build .out
        say ".."
        builder = Builder.new(@workspace_root)
        builder.verbose options[:verbose]
        builder.load File.read("#{@workspace_root}/#{mainfile}")
        builder.generate
        
        # Prepare compilers
        say "..."
        directory File.dirname(__FILE__) + "/tools/#{env.os_name}", "#{@workspace_root}/tmp/burn", :verbose => options[:verbose]
        
        # Finally compile
        say "...."
        redirect = ""
        if env.is_win? then
          command = ""
          ext = "bat"
          redirect = " > nul" if !options[:verbose]
          
        else
          command = "/bin/bash "
          ext = "sh"
          redirect = " > /dev/null" if !options[:verbose]
          
          # Set permissions to execute compilers
          Dir::glob("#{@workspace_root}/tmp/burn/cc65/bin/*65").each do |f|
            File.chmod(0777, f)
          end
          
        end
        run "#{command}#{@workspace_root}/tmp/burn/scripts/compile.#{ext} #{@workspace_root}/tmp/burn #{redirect}", :verbose => options[:verbose]
        
        # prepare customized emulator
        say "....."
        require 'base64'
        File.write(
          "#{@workspace_root}/tmp/burn/release/js/emulator.html", 
          File.read("#{@workspace_root}/tmp/burn/release/js/emulator.html")
            .gsub(/__@__TITLE__@__/, mainfile)
            .gsub(/__@__ROMDATA__@__/,
              Base64::strict_encode64(
                File.binread("#{@workspace_root}/tmp/burn/main.out")
              )
            )
        )
        copy_file "#{@workspace_root}/tmp/burn/main.out", "#{@workspace_root}/tmp/burn/release/js/main.out", :verbose => options[:verbose]
        
        say "successfully burned. #{@workspace_root}/tmp/burn/main.nes is available."
        
        # run simulator
        if options[:preview] then
          play
        else
          say "you can run this application by the following command:"
          say ""
          say "    burn play"
          say ""
        end
      end
    end
    
    desc "server <document_root>", "Run simple http server for emulator. This is mainly used by burn rubygem itself, not by user."
    option :debug, :type => :string, :aliases => '-d', :desc => "Debug mode"
    def server(document_root=nil)
      raise Exception.new("document_root must be specified when you would like to run http server") if document_root.nil?
      server = Burn::Util::Server.new(document_root)
      server.start
    end
    
    desc "play <file>", "Invoke application simulator."
    def play(mainfile=nil)
      mainfile="main.out" if mainfile.nil?
      env = Burn::Util::Os.new
      
      # boot up webrick httpserver to download emulator script
      command = "ruby " + File.dirname(__FILE__) + "/../../bin/burn server #{@workspace_root}/tmp/burn/release/js/ " + (options[:debug] ? "-d" : "")
      if env.is_win? then
        run "start #{command}", :verbose => options[:verbose]
      else
        run "#{command} &", :verbose => options[:verbose]
      end
      
      # wait for certain period of time to prevent browser from fetching game url too early
      sleep 1
      
      # open up browser
      uri = "http://127.0.0.1:17890/emulator.html"
      browser = options[:chrome] ? "chrome" : "firefox"
      if env.is_win? then
        run "start #{browser} #{uri}", :verbose => options[:verbose]
      elsif env.is_mac? then
        browser = "\"/Applications/Google Chrome.app\"" if options[:chrome]
        run "open -a #{browser} #{uri}", :verbose => options[:verbose]
      else
        run "/usr/bin/#{browser} #{uri}", :verbose => options[:verbose]
      end
    end
    
    desc "version", "Print version"
    map %w(-v --version) => :version
    def version
      say "burn #{Burn::VERSION}"
    end
    
    # desc "release", "To be designed"
    
  end
end