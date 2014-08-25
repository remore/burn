module Burn
  class BurnTasks < Thor
    include Thor::Actions
    class_option :debug, :type => :string, :aliases => '-d', :desc => "Debug mode"
    class_option :verbose, :type => :boolean, :desc => "Print logs as much as possible", :default => false
    default_task :fire
    
    def initialize(*args)
      super
      @workspace_root = Dir.getwd
      @os = Util::Os.new
    end
    
    desc "init", "Initialize environment"
    option :quick, :type=>:boolean, :desc=>"Make cc65 binaries available without gcc(however unstable. This option is not recommended.)"
    def init
      base_path = "#{File.dirname(__FILE__)}/tools"
      remove_dir base_path+ "/"+@os.name, :verbose => options[:verbose]
      Util::Unpack.new.unpack "#{base_path}/#{@os.name}.tar.gz", base_path
      if !@os.is_win? && !options[:quick] then
        Util::Unpack.new.unpack "#{base_path}/src.tar.gz", base_path
        run "/bin/bash #{File.dirname(__FILE__)}/tools/make_exec.sh #{base_path}"
        ["cc","ca","ld"].each do |pre|
          copy_file "#{base_path}/src/#{pre}65/#{pre}65", "#{base_path}/#{@os.name}/cc65/bin/#{pre}65", :force => true
        end
      end
      say <<-EOS
#{Util::Logo.new(VERSION).to_s}

successfully finished. you've got ready to burn.

EOS
    end
    
    desc "fire", "Create your application and Run them instantly"
    option :chrome, :type => :boolean, :aliases => '-c',  :desc => "[ROM mode only] Run emulator on chrome instead of firefox", :default => false
    option :preview, :type => :boolean, :aliases => '-p',  :desc => "[ROM mode only] Preview mode. By this, you can skip burning fuel DSL and focus on playing rom.", :default => false
    option :rom_server, :type => :boolean, :desc=>"[NOT FOR USER] Run simple http server for emulator", :default => false
    def fire(mainfile=nil)
      mainfile="main.rb" if mainfile.nil?
      load_conf_and_options(mainfile)
      if options[:rom_server] then
        server "#{@workspace_root}/tmp/burn/release/js/", mainfile
        
      else
        if @conf.app.target==:rom then
          make_and_play mainfile, options[:preview]
          
        elsif @conf.app.target==:telnet then
          say "starting telnet server #{@conf.server.ip_addr}:#{@conf.server.port}...."
          Server::Telnet.new(File.read("#{@workspace_root}/#{mainfile}"), @conf).start
        end
      end
      
    end
    
    desc "version", "Print version"
    map %w(-v --version) => :version
    def version
      say "burn #{Burn::VERSION}"
    end
    
    # desc "release", "To be designed"
    
    def self.source_root
      File.dirname(__FILE__) + "/.."
    end
    
    no_tasks do
      
      def make_and_play(mainfile=nil, preview=true)
        mainfile="main.rb" if mainfile.nil?
        
        if !File.exist?(mainfile) then
          help
        
        elsif !File.exist?("#{File.dirname(__FILE__)}/tools/#{@os.name}/cc65/bin/ld65#{".exe" if @os.is_win?}") then
          say <<-EOS
[ERROR] you are not ready to burn, most probably you haven't execute burn init command yet.
to fix this, try the following command:

    #{"sudo " if !@os.is_win?}burn init

EOS
        
        else
          _v = @conf.app.verbose
          if !preview then
            app_root = "#{@workspace_root}/tmp/burn"
            
            # init
            say "running burn v#{VERSION}..."
            remove_dir app_root, :verbose => _v
            empty_directory app_root, :verbose => _v
            Util::Unpack.new.unpack "#{File.dirname(__FILE__)}/tools/workspace_default.tar.gz", app_root
            
            # compile and build .nes
            say "."
            builder = Generator::RomBuilder.new(@workspace_root)
            builder.verbose _v
            builder.load File.read("#{@workspace_root}/#{mainfile}")
            builder.generate
            
            # Prepare compilers
            say ".."
            directory File.dirname(__FILE__) + "/tools/#{@os.name}", app_root, :verbose => _v
            
            # Finally compile
            say "..."
            redirect = ""
            if @os.is_win? then
              command = ""
              ext = "bat"
              redirect = " > nul" if !_v
              
            else
              command = "/bin/bash "
              ext = "sh"
              redirect = " > /dev/null" if !_v
              
              # Set permissions to execute compilers
              Dir::glob("#{app_root}/cc65/bin/*65").each do |f|
                File.chmod(0777, f)
              end
              
            end
            run "#{command}#{app_root}/scripts/compile.#{ext} #{app_root} #{redirect}", :verbose => _v
            
            # prepare customized emulator
            say "...."
            require 'base64'
            File.write(
              "#{app_root}/release/js/emulator.html", 
              File.read("#{app_root}/release/js/emulator.html")
                .gsub(/__@__TITLE__@__/, mainfile)
                .gsub(/__@__AUTHOR__@__/, "anonymous")
                .gsub(/__@__CREATED__@__/, Time.new.to_s)
                .gsub(/__@__ROM__@__/, mainfile)
                .gsub(/__@__ROMDATA__@__/,
                  Base64::strict_encode64(
                    File.binread("#{app_root}/main.nes")
                  )
                )
            )
            copy_file "#{app_root}/main.nes", "#{app_root}/release/js/main.nes", :verbose => _v
            
            say <<-EOS


Successfully burned. Congratulations!

The executable is available at:

    #{app_root}/main.nes

EOS
            
          end
          
          # boot up webrick httpserver to download emulator script
          command = "ruby " + File.dirname(__FILE__) + "/../../bin/burn fire #{mainfile} --rom-server " + (options[:debug] ? "-d" : "")
          if @os.is_win? then
            run "start #{command}", :verbose => _v
          else
            run "#{command} &", :verbose => _v
          end
          
          # wait for certain period of time to prevent browser from fetching game url too early
          # *DEFINITELY* TO BE REFACTORED
          # maybe better to use :StartCallback of WEBRICK?
          sleep 1
          
          # open up browser
          uri = "http://#{@conf.server.ip_addr}:#{@conf.server.port}/emulator.html"
          browser = options[:chrome] ? "chrome" : "firefox"
          if @os.is_win? then
            run "start #{browser} #{uri}", :verbose => _v
          elsif @os.is_mac? then
            browser = "\"/Applications/Google Chrome.app\"" if options[:chrome]
            run "open -a #{browser} #{uri}", :verbose => _v
          else
            run "/usr/bin/#{browser} #{uri}", :verbose => _v
          end
          
        end
      end
      
      desc "server <document_root>", "Run simple http server for emulator. This is mainly used by burn rubygem itself, not by user."
      def server(document_root=nil, mainfile)
        raise Exception.new("document_root must be specified when you would like to run http server") if document_root.nil?
        server = Server::Rom.new(document_root,@conf)
        server.start
      end
      
      def load_conf_and_options(mainfile)
        @conf = Configuration::Loader.new(File.read("#{@workspace_root}/#{mainfile}"))
        @conf.app.debug options[:debug]
        @conf.app.verbose options[:verbose]
      end
      
    end
    
  end
end